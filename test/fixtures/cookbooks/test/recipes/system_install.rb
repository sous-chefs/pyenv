# frozen_string_literal: true

version_3_7_2 = '3.7.2'
version_3_6_1 = '3.6.1'
version_2_7_15 = '2.7.15'

venv_root = '/opt/venv_test'

cookbook_file '/tmp/requirements.txt' do
  source 'requirements.txt'
  mode '0644'
end

# Install pyenv globally
pyenv_system_install 'system'

pyenv_python version_2_7_15
pyenv_global version_3_6_1
pyenv_python version_3_7_2

pyenv_plugin 'virtualenv' do
  git_url 'https://github.com/pyenv/pyenv-virtualenv'
end

pyenv_pip 'requests' do
  version '2.18.3'
end

pyenv_pip 'virtualenv' do
  version '16.2.0'
end

pyenv_script 'create virtualenv' do
  code "virtualenv #{venv_root}"
end

pyenv_pip '/tmp/requirements.txt' do
  virtualenv venv_root
  requirement true
end

pyenv_pip 'requests' do
  virtualenv venv_root
  action :uninstall
end
