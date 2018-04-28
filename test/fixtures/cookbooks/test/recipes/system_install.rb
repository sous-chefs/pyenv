# Install pyenv globally
pyenv_system_install 'system'

include_recipe 'test::_pyenv_python'
include_recipe 'test::_pyenv_global'
include_recipe 'test::_pyenv_plugin'
include_recipe 'test::_pyenv_pip'
