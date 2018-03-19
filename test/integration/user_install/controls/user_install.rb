# frozen_string_literal: true

global_python = '3.6.1'
user          = 'vagrant'

control 'pyenv should be installed' do
  title 'pyenv should be installed to the users home directory'

  desc "Can set global Python versions to #{global_python}"
  describe bash("sudo -H -u #{user} bash -c 'source /etc/profile.d/pyenv.sh && pyenv global'") do
    its('exit_status') { should eq(0) }
    its('stdout') { should match(global_python) }
    its('stdout') { should_not match('system') }
  end

  desc "Python #{global_python} should be installed"
  describe bash("sudo -H -u #{user} bash -c 'source /etc/profile.d/pyenv.sh && python --version'") do
    its('exit_status') { should eq(0) }
    its('stdout')      { should match(global_python) }
  end

  desc 'Plugin should be installed'
  describe bash("sudo -H -u #{user} bash -c 'source /etc/profile.d/pyenv.sh && pyenv virtualenv'") do
    its('stderr') { should match('pyenv-virtualenv') }
  end
end

control 'pyenv should be installed to the user path' do
  title "pyenv should be installed in the user's home"

  describe file('/etc/profile.d/pyenv.sh') do
    it { should be_file }
    it { should be_executable }
    its('owner') { should eq('root') }
  end

  describe directory("/home/#{user}/.pyenv") do
    it { should exist }
    its('owner') { should eq(user) }
  end

  describe file("/home/#{user}/.pyenv/bin/pyenv") do
    it { should be_file }
    it { should be_executable }
    its('owner') { should eq(user) }
  end

  describe file("/home/#{user}/.pyenv/shims/pip") do
    it { should be_file }
    it { should be_executable }
    its('owner') { should eq(user) }
  end
end
