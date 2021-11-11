# frozen_string_literal: true

global_python = '3.7.7'

control 'pyenv should be installed' do
  title 'pyenv should be installed globally'

  desc "Can set global Python versions to #{global_python}"
  describe bash('source /etc/profile.d/pyenv.sh && pyenv global') do
    its('exit_status') { should eq(0) }
    its('stdout')      { should match(global_python) }
    its('stdout')      { should_not match('system') }
  end

  desc "Python #{global_python} should be installed"
  describe bash('source /etc/profile.d/pyenv.sh && python --version') do
    its('exit_status') { should eq(0) }
    its('stdout')      { should match(global_python) }
  end

  desc 'Plugin should be installed'
  describe bash('source /etc/profile.d/pyenv.sh && pyenv virtualenv') do
    its('stderr') { should match('pyenv-virtualenv') }
  end

  desc 'Pip should install package requests'
  describe bash("sudo -H bash -c 'source /etc/profile.d/pyenv.sh && pip show requests'") do
    its('exit_status') { should eq(0) }
    its('stdout')      { should match('Version: 2.18.3') }
  end
end

control 'pyenv should be installed to the system path' do
  title 'pyenv should be installed in the global location'

  describe file('/etc/profile.d/pyenv.sh') do
    it { should be_file }
    it { should be_executable }
    its('owner') { should eq('root') }
    its('content') { should match(/^\s+pyenv_init="pyenv init -"/) }
    its('content') { should match(/Rehashing will fail in a system install\n\s+pyenv_init="pyenv init - --no-rehash"/m) }
    its('content') { should match(/^\s+eval "\$\(\$pyenv_init\)"/) }
  end

  describe directory('/usr/local/pyenv') do
    it { should exist }
    its('owner') { should eq('root') }
  end

  describe file('/usr/local/pyenv/bin/pyenv') do
    it { should be_file }
    it { should be_executable }
    its('owner') { should eq('root') }
  end

  describe file('/usr/local/pyenv/shims/pip') do
    it { should be_file }
    it { should be_executable }
    its('owner') { should eq('root') }
  end
end

control 'Path' do
  impact 1
  title 'pyenv should be on the path'
  desc 'pyenv bin and shims should be on the path'

  describe bash('source /etc/profile.d/pyenv.sh && echo $PATH') do
    its('stdout') { should match /shims/ }
  end
end

control 'Shims' do
  impact 1
  title 'Pyenv shims should contain the correct Python'
  desc 'When pyen shims is run we should have the correct version of Python shimmed'
  describe bash('source /etc/profile.d/pyenv.sh && pyenv shims') do
    its('stdout') { should match /shims/ }
    its('stdout') { should match /python3.7/ }
  end
end

control 'pyenv version' do
  impact 1
  title 'Installed Pyenv Versions'
  desc 'Pyenv versions should contain the version of python we have installed'
  describe command('source /etc/profile.d/pyenv.sh && pyenv versions --bare') do
    its('stdout') { should eq global_python }
  end
end
