# frozen_string_literal: true

global_python = '3.6.1'

control 'pyenv should be installed' do
  title 'pyenv should be installed to the users home directory'

  desc 'pyenv should be installed'
  describe bash('sudo -H -u vagrant bash -c "source /etc/profile.d/pyenv.sh && pyenv global"') do
    its('exit_status') { should eq 0 }
    # its('stdout') { should include(global_python) }
    # its('stdout') { should_not match(/system/) }
  end

  desc "Python #{global_python} should be installed"
  describe bash('sudo -H -u vagrant bash -c "source /etc/profile.d/pyenv.sh && pyenv versions"') do
    its('exit_status') { should eq 0 }
    its('stdout')      { should match(global_python) }
  end

  describe file('/home/vagrant/.pyenv/versions') do
    it { should exist }
    it { should be_writable.by_user('vagrant') }
  end
end

# control 'Global Python' do
#   title 'pyenv should be installed globally'

#   desc "Can set global Python version to #{global_python}"
#   describe bash('sudo -H -u vagrant bash -c "source /etc/profile.d/pyenv.sh && pyenv versions --bare"') do
#     its('exit_status') { should eq 0 }
#     its('stdout') { should include(global_python) }
#   end
# end
