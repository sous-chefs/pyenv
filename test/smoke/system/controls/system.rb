# encoding: utf-8
# copyright: 2017, The Authors

control 'system-install-1.0' do
  impact 1.0
  title 'pyenv system installation checks'

  describe file('/etc/profile.d/pyenv.sh') do
    it { should be_file }
    it { should be_executable }
    its('owner')   { should eq('root') }
    its('group')   { should eq('root') }
  end

  describe directory('/usr/local/pyenv') do
    it { should exist }
    its('owner') { should eq('root') }
    its('group') { should eq('root') }
  end

  describe file('/usr/local/pyenv/bin/pyenv') do
    it { should be_file }
    it { should be_executable }
    its('owner') { should eq('root') }
    its('group') { should eq('root') }
  end

  describe file('/usr/local/pyenv/shims/pip') do
    it { should be_file }
    it { should be_executable }
    its('owner') { should eq('root') }
    its('group') { should eq('root') }
  end

  describe command('ls -la /usr/local/pyenv/versions') do
    its('stdout') { should match('2.7.6') }
    its('stdout') { should match('3.6.0') }
  end

  describe command('/usr/local/pyenv/shims/python --version') do
    its('stderr') { should match('2.7.6') }
  end
end
