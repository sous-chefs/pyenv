# Install pyenv
# and make it avilable to the selected user

version   = platform_family?('fedora') && node['platform_version'].to_i >= 45 ? '3.15.2' : '3.12.16'
user      = 'vagrant'
venv_root = "/home/#{user}/venv_test"

cookbook_file '/tmp/requirements.txt' do
  source 'requirements.txt'
  owner user
  group user
  mode '0644'
end

pyenv_install 'user' do
  user user
end

pyenv_python version do
  user user
end

pyenv_global version do
  user user
end

pyenv_plugin 'virtualenv' do
  git_url 'https://github.com/pyenv/pyenv-virtualenv'
  user    user
end

pyenv_pip 'requests' do
  version '2.32.3'
  user    user
end

pyenv_script 'create virtualenv' do
  code "python -m venv #{venv_root}"
  creates "#{venv_root}/bin/activate"
  user user
end

pyenv_pip '/tmp/requirements.txt' do
  virtualenv venv_root
  requirement true
end

pyenv_pip 'requests' do
  virtualenv venv_root
  action :uninstall
end
