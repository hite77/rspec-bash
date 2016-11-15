require 'rspec/expectations'

RSpec::Matchers.define :be_called_with_arguments do |*expected_argument_list|
  chain :times do |expected_invocations|
    @expected_invocations = expected_invocations
  end

  match do |actual_command|
    called_with_correct_args = actual_command.called_with_args?(*expected_argument_list)
    if @expected_invocations
      called_correct_number_of_times =
        actual_command.call_count(*expected_argument_list) == @expected_invocations
    else
      called_correct_number_of_times = true
    end

    called_with_correct_args && called_correct_number_of_times
  end
end
