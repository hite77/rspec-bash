require 'spec_helper'

describe 'StubbedCommand' do
  include Rspec::Bash

  before(:all) do
     @stubbed_env = create_stubbed_env
  end

  context 'first stub' do
    before(:all) do
      @command1_stub = @stubbed_env.stub_command('command1')
      @command1_stub.outputs('hello')
      
      @stdout, @stderr, @status = @stubbed_env.execute_inline('command1 first_argument second_argument')
    end

    it 'outputs hello to stdout' do
      expect(@stdout).to eql 'hello'
    end
  end

  context 'second stub' do
    before(:all) do
      @command1_stub = @stubbed_env.stub_command('command1')
      @command1_stub.outputs('world')
      
      @stdout, @stderr, @status = @stubbed_env.execute_inline('command1 first_argument second_argument')
    end

    it 'outputs world to stdout' do
      expect(@stdout).to eql 'world'
    end
  end
end
