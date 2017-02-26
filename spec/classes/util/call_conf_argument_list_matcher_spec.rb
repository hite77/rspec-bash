require 'spec_helper'
include Rspec::Bash::Util

describe 'CallConfArgumentListMatcher' do
  context '#get_best_call_conf' do
    context 'given a call conf list with a with multiple sets of args, output and statuscodes' do
      let(:call_conf_list) do
        [
          {
            args: [],
            statuscode: 6,
            outputs: [
              {
                target: :stdout,
                content: 'seventh_content'
              }
            ]
          },
          {
            args: %w(first_argument second_argument third_argument),
            statuscode: 1,
            outputs: [
              {
                target: :stdout,
                content: 'second_content'
              }
            ]
          },
          {
            args: ['first_argument', anything, anything],
            statuscode: 3,
            outputs: [
              {
                target: :stdout,
                content: 'fourth_content'
              }
            ]
          },
          {
            args: [anything, 'second_argument'],
            statuscode: 4,
            outputs: [
              {
                target: :stdout,
                content: 'fifth_content'
              }
            ]
          },
          {
            args: %w(first_argument second_argument),
            statuscode: 0,
            outputs: [
              {
                target: :stdout,
                content: 'first_content'
              }
            ]
          },
          {
            args: %w(first_argument second_argument),
            statuscode: 2,
            outputs: [
              {
                target: :stdout,
                content: 'third_content'
              }
            ]
          },
          {
            args: [anything, anything, anything, anything],
            statuscode: 5,
            outputs: [
              {
                target: :stdout,
                content: 'sixth_content'
              }
            ]
          }
        ]
      end

      it 'returns the longest, non-anything conf match' do
        argument_list_from_call = %w(first_argument second_argument third_argument)
        subject = CallConfArgumentListMatcher.new(call_conf_list)
        call_conf_match = subject.get_best_call_conf(*argument_list_from_call)
        expect(call_conf_match).to eql call_conf_list.at(1)
      end

      it 'returns the last longest, non-anything conf match for multiple exact matches' do
        argument_list_from_call = %w(first_argument second_argument)
        subject = CallConfArgumentListMatcher.new(call_conf_list)
        call_conf_match = subject.get_best_call_conf(*argument_list_from_call)
        expect(call_conf_match).to eql call_conf_list.at(5)
      end

      it 'returns the longest conf match for any_arg v. anything matches' do
        argument_list_from_call = %w(first_argument second_argument third_argument fourth_argument)
        subject = CallConfArgumentListMatcher.new(call_conf_list)
        call_conf_match = subject.get_best_call_conf(*argument_list_from_call)
        expect(call_conf_match).to eql call_conf_list.at(6)
      end
    end
    context 'given a call conf list with a with no all matchers' do
      let(:call_conf_list) do
        [
          {
            args: %w(first_argument second_argument),
            statuscode: 0,
            outputs: [
              {
                target: :stdout,
                content: 'first_content'
              }
            ]
          },
          {
            args: %w(first_argument second_argument third_argument),
            statuscode: 1,
            outputs: [
              {
                target: :stdout,
                content: 'second_content'
              }
            ]
          },
          {
            args: %w(first_argument second_argument),
            statuscode: 2,
            outputs: [
              {
                target: :stdout,
                content: 'third_content'
              }
            ]
          },
          {
            args: ['first_argument', anything, 'third_argument'],
            statuscode: 3,
            outputs: [
              {
                target: :stdout,
                content: 'fourth_content'
              }
            ]
          },
          {
            args: [anything, 'second_argument'],
            statuscode: 4,
            outputs: [
              {
                target: :stdout,
                content: 'fifth_content'
              }
            ]
          },
          {
            args: [anything, anything, anything, anything],
            statuscode: 5,
            outputs: [
              {
                target: :stdout,
                content: 'sixth_content'
              }
            ]
          }
        ]
      end

      it 'returns an empty conf for no matches' do
        argument_list_from_call =
          %w(first_argument second_argument third_argument fourth_argument fifth_argument)
        subject = CallConfArgumentListMatcher.new(call_conf_list)
        call_conf_match = subject.get_best_call_conf(*argument_list_from_call)
        expect(call_conf_match).to be_empty
      end
    end
  end
  context '#get_call_conf_matches' do
    context 'given a call conf list with a with multiple sets of args, output and statuscodes' do
      let(:call_conf_list) do
        [
          {
            args: %w(first_argument second_argument),
            statuscode: 0,
            outputs: [
              {
                target: :stdout,
                content: 'first_content'
              }
            ]
          },
          {
            args: %w(first_argument second_argument third_argument),
            statuscode: 1,
            outputs: [
              {
                target: :stdout,
                content: 'second_content'
              }
            ]
          },
          {
            args: %w(first_argument second_argument),
            statuscode: 2,
            outputs: [
              {
                target: :stdout,
                content: 'third_content'
              }
            ]
          },
          {
            args: ['first_argument', anything, 'third_argument'],
            statuscode: 3,
            outputs: [
              {
                target: :stdout,
                content: 'fourth_content'
              }
            ]
          },
          {
            args: [anything, 'second_argument'],
            statuscode: 4,
            outputs: [
              {
                target: :stdout,
                content: 'fifth_content'
              }
            ]
          },
          {
            args: [anything, anything, anything, anything],
            statuscode: 5,
            outputs: [
              {
                target: :stdout,
                content: 'sixth_content'
              }
            ]
          },
          {
            args: [],
            statuscode: 6,
            outputs: [
              {
                target: :stdout,
                content: 'seventh_content'
              }
            ]
          }
        ]
      end

      it 'returns the correct confs for a single exact/anything argument match' do
        argument_list_from_call = %w(first_argument second_argument third_argument)
        subject = CallConfArgumentListMatcher.new(call_conf_list)
        call_conf_match_list = subject.get_call_conf_matches(*argument_list_from_call)
        expect(call_conf_match_list).to eql call_conf_list.values_at(1, 3, 6)
      end

      it 'returns the correct confs for multiple exact/anything argument matches' do
        argument_list_from_call = %w(first_argument second_argument)
        subject = CallConfArgumentListMatcher.new(call_conf_list)
        call_conf_match_list = subject.get_call_conf_matches(*argument_list_from_call)
        expect(call_conf_match_list).to eql call_conf_list.values_at(0, 2, 4, 6)
      end

      it 'returns the correct confs for the all argument match' do
        argument_list_from_call = %w(first_argument)
        subject = CallConfArgumentListMatcher.new(call_conf_list)
        call_conf_match_list = subject.get_call_conf_matches(*argument_list_from_call)
        expect(call_conf_match_list).to eql call_conf_list.values_at(6)
      end
    end
  end
  context '#args_match?' do
    context 'given a call conf list with a with multiple sets of args, output and statuscodes' do
      let(:call_conf_list) do
        [
          {
            args: %w(first_argument second_argument),
            statuscode: 0,
            outputs: [
              {
                target: :stdout,
                content: 'first_content'
              }
            ]
          },
          {
            args: %w(first_argument second_argument third_argument),
            statuscode: 1,
            outputs: [
              {
                target: :stdout,
                content: 'second_content'
              }
            ]
          },
          {
            args: %w(first_argument second_argument),
            statuscode: 2,
            outputs: [
              {
                target: :stdout,
                content: 'third_content'
              }
            ]
          },
          {
            args: ['first_argument', anything, 'third_argument'],
            statuscode: 3,
            outputs: [
              {
                target: :stdout,
                content: 'fourth_content'
              }
            ]
          },
          {
            args: [anything, 'second_argument'],
            statuscode: 4,
            outputs: [
              {
                target: :stdout,
                content: 'fifth_content'
              }
            ]
          },
          {
            args: [anything, anything, anything, anything],
            statuscode: 5,
            outputs: [
              {
                target: :stdout,
                content: 'sixth_content'
              }
            ]
          },
          {
            args: [],
            statuscode: 6,
            outputs: [
              {
                target: :stdout,
                content: 'seventh_content'
              }
            ]
          }
        ]
      end

      it 'returns the correct confs for a single exact/anything argument match' do
        argument_list_from_call = %w(first_argument second_argument third_argument)
        subject = CallConfArgumentListMatcher.new(call_conf_list)
        actual_args_match = subject.args_match?(*argument_list_from_call)
        expect(actual_args_match).to be true
      end

      it 'returns the correct confs for multiple exact/anything argument matches' do
        argument_list_from_call = %w(first_argument second_argument)
        subject = CallConfArgumentListMatcher.new(call_conf_list)
        actual_args_match = subject.args_match?(*argument_list_from_call)
        expect(actual_args_match).to be true
      end

      it 'returns the correct confs for the all argument match' do
        argument_list_from_call = %w(first_argument)
        subject = CallConfArgumentListMatcher.new(call_conf_list)
        actual_args_match = subject.args_match?(*argument_list_from_call)
        expect(actual_args_match).to be true
      end
    end
    context 'given a call conf list with a with no all matchers' do
      let(:call_conf_list) do
        [
          {
            args: %w(first_argument second_argument),
            statuscode: 0,
            outputs: [
              {
                target: :stdout,
                content: 'first_content'
              }
            ]
          },
          {
            args: %w(first_argument second_argument third_argument),
            statuscode: 1,
            outputs: [
              {
                target: :stdout,
                content: 'second_content'
              }
            ]
          },
          {
            args: %w(first_argument second_argument),
            statuscode: 2,
            outputs: [
              {
                target: :stdout,
                content: 'third_content'
              }
            ]
          },
          {
            args: ['first_argument', anything, 'third_argument'],
            statuscode: 3,
            outputs: [
              {
                target: :stdout,
                content: 'fourth_content'
              }
            ]
          },
          {
            args: [anything, 'second_argument'],
            statuscode: 4,
            outputs: [
              {
                target: :stdout,
                content: 'fifth_content'
              }
            ]
          },
          {
            args: [anything, anything, anything, anything],
            statuscode: 5,
            outputs: [
              {
                target: :stdout,
                content: 'sixth_content'
              }
            ]
          }
        ]
      end

      it 'returns the correct confs for a single exact/anything argument match' do
        argument_list_from_call = %w(first_argument second_argument third_argument)
        subject = CallConfArgumentListMatcher.new(call_conf_list)
        actual_args_match = subject.args_match?(*argument_list_from_call)
        expect(actual_args_match).to be true
      end

      it 'returns the correct confs for multiple exact/anything argument matches' do
        argument_list_from_call = %w(first_argument second_argument)
        subject = CallConfArgumentListMatcher.new(call_conf_list)
        actual_args_match = subject.args_match?(*argument_list_from_call)
        expect(actual_args_match).to be true
      end

      it 'returns the correct confs for the all argument match' do
        argument_list_from_call = %w(first_argument)
        subject = CallConfArgumentListMatcher.new(call_conf_list)
        actual_args_match = subject.args_match?(*argument_list_from_call)
        expect(actual_args_match).to be false
      end
    end
  end
end