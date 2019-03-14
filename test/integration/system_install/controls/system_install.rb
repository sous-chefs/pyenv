# frozen_string_literal: true

global_python_3_6_1 = '3.6.1'
python_3_7_2 = '3.7.2'
python_2_7_15 = '2.7.15'

venv_root = '/opt/venv_test'

control 'pyenv should be installed' do
  title 'pyenv should be installed globally'
  desc "Can set global Python versions to #{global_python_3_6_1} and add the ability to see other python versions present (#{python_2_7_15} and #{python_3_7_2})"
  
  describe bash('source /etc/profile.d/pyenv.sh && pyenv global') do
    its('exit_status') { should eq(0) }
    its('stdout')      { should match(global_python_3_6_1) }
    its('stdout')      { should_not match(python_3_7_2) }
    its('stdout')      { should_not match(python_2_7_15) }
    its('stdout')      { should_not match('system') }
  end

  describe bash('source /etc/profile.d/pyenv.sh && pyenv versions') do
    its('exit_status') { should eq(0) }
    its('stdout')      { should match(python_3_7_2) }
    its('stdout')      { should match(global_python_3_6_1) }
    its('stdout')      { should match(python_2_7_15) }
    its('stdout')      { should match('system') }
  end

  desc "Python Global #{global_python_3_6_1} should be installed"
  describe bash('source /etc/profile.d/pyenv.sh && python --version') do
    its('exit_status') { should eq(0) }
    its('stdout')      { should match(global_python_3_6_1) }
  end

  desc "Python #{python_3_7_2} should be installed"
  describe bash("source /etc/profile.d/pyenv.sh && PYENV_VERSION=#{python_3_7_2} python --version") do
    its('exit_status') { should eq(0) }
    its('stdout')      { should match(python_3_7_2) }
  end

  desc "Python #{python_2_7_15} should be installed"
  describe bash("source /etc/profile.d/pyenv.sh && echo \"import sys; print(sys.version)\" | PYENV_VERSION=#{python_2_7_15} python -") do
    its('exit_status') { should eq(0) }
    its('stdout')      { should match(python_2_7_15) }
  end
end

control 'pyenv on global configs should be configured' do
  title 'pyenv on global configs should be configured properly'

  desc 'Plugin should be installed'
  describe bash('source /etc/profile.d/pyenv.sh && pyenv virtualenv') do
    its('stderr') { should match('pyenv-virtualenv') }
  end

  desc 'Pip should install package requests'
  describe bash("sudo -H bash -c 'source /etc/profile.d/pyenv.sh && pip show requests'") do
    its('exit_status') { should eq(0) }
    its('stdout')      { should match('Version: 2.18.3') }
  end

  desc 'Pip should install package virtualenv'
  describe bash("sudo -H bash -c 'source /etc/profile.d/pyenv.sh && pip show virtualenv'") do
    its('exit_status') { should eq(0) }
    its('stdout')      { should match('Version: 16.2.0') }
  end

  desc 'Pip should install package requests inside virtualenv according to requirements.txt'
  describe bash("sudo -H bash -c 'source /etc/profile.d/pyenv.sh && #{venv_root}/bin/pip show fire'") do
    its('exit_status') { should eq(0) }
    its('stdout')      { should match('Version: 0.1.2') }
  end

  desc 'Pip should uninstall package requests inside virtualenv'
  describe bash("sudo -H bash -c 'source /etc/profile.d/pyenv.sh && #{venv_root}/bin/pip show requests'") do
    its('exit_status') { should eq(1) }
  end
end

control 'pyenv should be installed to the system path' do
  title 'pyenv should be installed in the global location'

  describe file('/etc/profile.d/pyenv.sh') do
    it { should be_file }
    it { should be_executable }
    its('owner') { should eq('root') }
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

control 'virtualenv should be created' do
  title "virtualenv should be created in #{venv_root}"

  describe directory(venv_root) do
    it { should exist }
    its('owner') { should eq('root') }
  end

  describe file("#{venv_root}/bin/activate") do
    it { should be_file }
    its('owner') { should eq('root') }
  end
end
