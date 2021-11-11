# Install Python system wide
# and make it the global default

version = '3.7.7'
local_folder = '/opt/pyenv_test'

directory local_folder

# cookbook_file '/tmp/requirements.txt' do
#   source 'requirements.txt'
#   mode '0644'
# end

pyenv_install 'system'

pyenv_rehash 'for-new-python'

pyenv_python version

pyenv_local version do
  path local_folder
  user 'root'
end

pyenv_global version

pyenv_plugin 'virtualenv' do
  git_url 'https://github.com/pyenv/pyenv-virtualenv'
end

pyenv_pip 'requests' do
  version '2.18.3'
end

# pyenv_pip '/tmp/requirements.txt' do
#   # virtualenv local_folder
#   requirement true
#   user 'root'
# end

# pyenv_pip 'urllib3' do
#   # virtualenv local_folder
#   action :upgrade
#   user 'root'
#   version '1.25.11'
# end

# pyenv_pip 'requests' do
#   # virtualenv local_folder
#   user 'root'
#   action :uninstall
# end
