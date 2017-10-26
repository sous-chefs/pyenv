# encoding: utf-8
# copyright: 2017, The Authors

control 'user-install-1.0' do
  impact 1.0
  title 'pyenv user installation checks'

  describe file('/etc/profile.d/pyenv.sh') do
    it { should be_file }
    it { should be_executable }
    its('owner')   { should eq('root') }
    its('group')   { should eq('root') }
  end

  describe directory('/home/kitchen/.pyenv') do
    it { should exist }
    its('owner') { should eq('kitchen') }
    its('group') { should eq('root') }
  end

  describe file('/home/kitchen/.pyenv/bin/pyenv') do
    it { should be_file }
    it { should be_executable }
    its('owner') { should eq('kitchen') }
    its('group') { should eq('root') }
  end

  describe file('/home/kitchen/.pyenv/shims/pip') do
    it { should be_file }
    it { should be_executable }
    its('owner') { should eq('kitchen') }
    its('group') { should eq('root') }
  end

  describe command('ls -la /home/kitchen/.pyenv/versions') do
    its('stdout') { should match('2.7.6') }
    its('stdout') { should match('3.6.0') }
  end

  describe command('/home/kitchen/.pyenv/shims/python --version') do
    its('stderr') { should match('2.7.6') }
  end
end
