# frozen_string_literal: true

global_python = '3.6.1'

control 'pyenv should be installed' do
  title 'pyenv should be installed globally'

  desc "Can set global Python versions to #{global_python}"
  describe bash('source /etc/profile.d/pyenv.sh && pyenv versions --bare') do
    its('exit_status') { should eq(0) }
  end
end

control 'pyenv should be installed to the system path' do
  title 'pyenv should be installed in the global location'

  describe file('/usr/local/pyenv') do
    it { should exist }
    it { should be_directory }
  end
end
