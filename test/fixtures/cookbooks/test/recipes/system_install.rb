# frozen_string_literal: true

version = '3.6.1'

# Install pyenv globally
pyenv_system_install 'system'

pyenv_python version

pyenv_global version

pyenv_plugin 'virtualenv' do
  git_url 'https://github.com/pyenv/pyenv-virtualenv'
end
