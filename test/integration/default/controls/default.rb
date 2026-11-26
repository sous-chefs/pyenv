# frozen_string_literal: true

control 'pyenv-installation' do
  describe command('/usr/local/pyenv/bin/pyenv --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/pyenv/) }
  end
end
