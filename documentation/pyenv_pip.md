# `pyenv_pip`

Used to install a Python package into the selected pyenv environment.

```ruby
pyenv_pip 'requests' do
  virtualenv  # Optional: if passed, pip inside provided virtualenv would be used (by default system's pip)
  version     # Optional: if passed, the version the python package to install
  user        # Optional: if passed, the user to install the python module for
  umask       # Optional: if passed, the umask to set before installing the python module
  options     # Optional: if passed, pip would install/uninstall packages with given options
  requirement # Optional: if true passed, install/uninstall requirements file passed with name property
  editable    # Optional: if true passed, install package in editable mode
end
```

The pyenv_pip resource has the following actions:

* `:install` - Default. Install a python package. If a version is specified, install the specified version of the python package.
* `:upgrade` - Install/upgrade a python package. Call `install` command with `--upgrade` flag. If version is not specified, latest version will be installed.
* `:uninstall` - Uninstall a python package.
