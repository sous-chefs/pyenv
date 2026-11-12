# frozen_string_literal: true

require 'spec_helper'
require_relative '../libraries/helpers'

describe PyEnv::Cookbook::ScriptHelpers do
  let(:helper) do
    Class.new do
      include PyEnv::Cookbook::ScriptHelpers
      attr_accessor :node
    end.new
  end

  it 'explains the required installation ordering instead of dereferencing missing state' do
    helper.node = Struct.new(:run_state).new({})
    expect { helper.root_path }.to raise_error(Chef::Exceptions::ValidationFailed, /Declare pyenv_install/)
  end

  it 'uses the installation root established during the converge' do
    helper.node = Struct.new(:run_state).new({ 'sous-chefs' => { 'pyenv' => { 'root_path' => { 'prefix' => '/srv/pyenv' } } } })
    expect(helper.root_path).to eq('/srv/pyenv')
  end
end
