# frozen_string_literal: true

version = '3.6.1'

# Install pyenv globally
pyenv_system_install 'system'

# Install a Python version
pyenv_python version

# Set that Python as the global Python
pyenv_global version
