# Install pyenv and makes it avilable to the selected user
version = '3.6.1'

# Keeps the pyenv install upto date
pyenv_user_install 'vagrant'

pyenv_python version do
  user 'vagrant'
end

# pyenv_global version do
#   user 'vagrant'
# end
