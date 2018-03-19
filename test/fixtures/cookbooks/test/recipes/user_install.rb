# Install pyenv and makes it avilable to the selected user
version = '3.6.1'
user    = 'vagrant'

pyenv_user_install user

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
  version '2.18.3'
  user    user
end
