# frozen_string_literal: true

require 'spec_helper'
require 'ostruct'

RSpec.shared_context 'pyenv installation' do
  stubs_for_resource do |resource|
    next unless resource.resource_name.to_s.start_with?('pyenv_')

    resource.node.run_state['sous-chefs'] = { 'pyenv' => { 'root_path' => { 'prefix' => '/usr/local/pyenv' } } }
  end
end

describe 'pyenv_install' do
  platform 'ubuntu', '22.04'
  step_into :pyenv_install

  context 'system installation' do
    recipe { pyenv_install 'system' }

    it 'installs compiler and Python build prerequisites' do
      expect(chef_run).to install_build_essential('build packages')
      packages = chef_run.resource_collection.select { |r| r.respond_to?(:package_name) }.flat_map(&:package_name)
      expect(packages).to include('libssl-dev', 'libffi-dev', 'libncurses-dev', 'git')
      expect(packages).not_to include('python-openssl')
    end

    it 'creates the root directory and preserves the default repository' do
      expect(chef_run).to create_directory('/usr/local/pyenv').with(recursive: true, owner: 'root')
      expect(chef_run).to checkout_git('/usr/local/pyenv').with(repository: 'https://github.com/pyenv/pyenv.git', revision: 'master')
    end

    it 'installs the shell profile and shim directories' do
      expect(chef_run).to create_template('/etc/profile.d/pyenv.sh')
      expect(chef_run).to create_directory('/usr/local/pyenv/shims')
    end
  end

  context 'user installation' do
    recipe do
      pyenv_install 'user' do
        user 'example'
        home_dir '/home/example'
      end
    end

    it 'creates the user-owned root before checkout' do
      expect(chef_run).to create_directory('/home/example/.pyenv').with(owner: 'example', group: 'example', recursive: true)
      expect(chef_run).to checkout_git('/home/example/.pyenv').with(user: 'example')
    end
  end

  context 'Ubuntu 20.04 ESM installation' do
    platform 'ubuntu', '20.04'
    recipe { pyenv_install 'system' }

    it 'uses OpenSSL development headers without the obsolete Python 2 package' do
      packages = chef_run.resource_collection.select { |r| r.respond_to?(:package_name) }.flat_map(&:package_name)
      expect(packages).to include('libssl-dev')
      expect(packages).not_to include('python-openssl')
    end
  end
end

describe 'pyenv_python' do
  platform 'ubuntu', '22.04'
  include_context 'pyenv installation'
  step_into :pyenv_python

  before do
    allow(File).to receive(:directory?).and_call_original
    allow(File).to receive(:directory?).with('/usr/local/pyenv/versions/3.12.12').and_return(installed)
  end

  context 'installing a missing version' do
    let(:installed) { false }
    recipe { pyenv_python '3.12.12' }
    it { is_expected.to run_pyenv_script('pyenv install  3.12.12') }
  end

  context 'installing an existing version' do
    let(:installed) { true }
    recipe { pyenv_python '3.12.12' }
    it { is_expected.not_to run_pyenv_script('pyenv install  3.12.12') }
  end

  context 'uninstalling an existing version' do
    let(:installed) { true }
    recipe { pyenv_python('3.12.12') { action :uninstall } }
    it { is_expected.to run_pyenv_script('pyenv uninstall -f 3.12.12') }
  end

  context 'uninstalling a missing version' do
    let(:installed) { false }
    recipe { pyenv_python('3.12.12') { action :uninstall } }
    it { is_expected.not_to run_pyenv_script('pyenv uninstall -f 3.12.12') }
  end
end

describe 'pyenv_script' do
  platform 'ubuntu', '22.04'
  include_context 'pyenv installation'
  step_into :pyenv_script
  recipe do
    pyenv_script 'check Python' do
      code 'python --version'
      pyenv_version '3.12.12'
      environment 'EXAMPLE' => 'value'
      creates '/tmp/python-result'
    end
  end

  it 'executes in the installed pyenv environment and preserves command guards' do
    command = chef_run.execute('check Python')
    expect(command.command).to include('PYENV_ROOT="/usr/local/pyenv"', 'PYENV_VERSION="3.12.12"', 'python --version')
    expect(command.environment).to include('PYENV_ROOT' => '/usr/local/pyenv', 'EXAMPLE' => 'value')
    expect(command.creates).to eq('/tmp/python-result')
  end
end

describe 'pyenv_global' do
  platform 'ubuntu', '22.04'
  include_context 'pyenv installation'
  step_into :pyenv_global
  recipe { pyenv_global '3.12.12' }

  before do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/usr/local/pyenv/version').and_return(false)
  end

  it 'sets the requested global version' do
    expect(chef_run).to run_pyenv_script('globals').with(code: 'pyenv global 3.12.12')
  end

  context 'when the version already matches' do
    before do
      allow(File).to receive(:exist?).with('/usr/local/pyenv/version').and_return(true)
      allow(IO).to receive(:read).and_call_original
      allow(IO).to receive(:read).with('/usr/local/pyenv/version').and_return("3.12.12\n")
    end

    it { is_expected.not_to run_pyenv_script('globals') }
  end
end

describe 'pyenv_local' do
  platform 'ubuntu', '22.04'
  include_context 'pyenv installation'
  step_into :pyenv_local
  recipe { pyenv_local('3.12.12') { path '/opt/example' } }

  before do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('/opt/example/.python-version').and_return(false)
  end

  it 'sets the requested version in the requested working directory' do
    expect(chef_run).to run_pyenv_script('local').with(code: 'pyenv local 3.12.12', cwd: '/opt/example')
  end
end

describe 'pyenv_plugin' do
  platform 'ubuntu', '22.04'
  include_context 'pyenv installation'
  step_into :pyenv_plugin
  recipe do
    pyenv_plugin 'virtualenv' do
      git_url 'https://github.com/pyenv/pyenv-virtualenv.git'
      git_ref 'v1.2.4'
    end
  end

  it 'syncs the requested plugin revision into the installed root' do
    expect(chef_run).to sync_git('Install virtualenv plugin').with(
      destination: '/usr/local/pyenv/plugins/virtualenv', reference: 'v1.2.4'
    )
  end
end

describe 'pyenv_rehash' do
  platform 'ubuntu', '22.04'
  step_into :pyenv_rehash
  recipe { pyenv_rehash 'updated shims' }
  it { is_expected.to run_pyenv_script('pyenv rehash').with(code: 'pyenv rehash') }
end

describe 'pyenv_pip' do
  platform 'ubuntu', '22.04'
  include_context 'pyenv installation'
  step_into :pyenv_pip
  let(:installed_version) { nil }

  stubs_for_provider do |provider|
    next unless provider.new_resource.resource_name == :pyenv_pip

    output = installed_version ? "Name: requests\nVersion: #{installed_version}\n" : ''
    allow(provider).to receive(:shell_out).and_return(OpenStruct.new(stdout: output))
  end

  context 'installing a missing package' do
    recipe { pyenv_pip('requests') { version '2.32.3' } }
    it { is_expected.to run_pyenv_script('requests').with(code: 'pip install   requests==2.32.3') }
  end

  context 'installing the requested existing version' do
    let(:installed_version) { '2.32.3' }
    recipe { pyenv_pip('requests') { version '2.32.3' } }
    it { is_expected.not_to run_pyenv_script('requests') }
  end

  context 'upgrading a different package version' do
    let(:installed_version) { '2.31.0' }
    recipe do
      pyenv_pip 'requests' do
        version '2.32.3'
        action :upgrade
      end
    end
    it { is_expected.to run_pyenv_script('requests').with(code: 'pip install --upgrade  requests==2.32.3') }
  end

  context 'uninstalling an installed package' do
    let(:installed_version) { '2.32.3' }
    recipe { pyenv_pip('requests') { action :uninstall } }
    it { is_expected.to run_pyenv_script('requests') }
  end

  context 'uninstalling a missing package' do
    recipe { pyenv_pip('requests') { action :uninstall } }
    it { is_expected.not_to run_pyenv_script('requests') }
  end
end
