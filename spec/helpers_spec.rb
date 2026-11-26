# frozen_string_literal: true

require 'spec_helper'
require_relative '../libraries/helpers'

describe PyEnv::Cookbook::ScriptHelpers do
  let(:helper) do
    Class.new do
      include PyEnv::Cookbook::ScriptHelpers
      include Chef::DSL::PlatformIntrospection
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

  it 'uses the Leap 16 zlib development provider without requesting its conflicting legacy package' do
    helper.node = Chef::Node.new
    helper.node.automatic['platform'] = 'opensuseleap'
    helper.node.automatic['platform_family'] = 'suse'
    helper.node.automatic['platform_version'] = '16.0'
    expect(helper.pyenv_prerequisites).to include('zlib-ng-compat-devel')
    expect(helper.pyenv_prerequisites).not_to include('zlib-devel')
  end

  %w(debian rhel amazon suse).each do |family|
    it "includes source archive tools for #{family} systems" do
      helper.node = Chef::Node.new
      helper.node.automatic['platform'] = family
      helper.node.automatic['platform_family'] = family
      helper.node.automatic['platform_version'] = '12.0'
      expect(helper.pyenv_prerequisites).to include('tar', 'gzip', 'patch')
    end
  end
end
