# chef-pyenv Changelog

## 1.0.0 (BREAKING CHANGES!!)
Refactor and update the legacy code base. Recipes are no longer provided, and custom resources are used to manage pyenv installations instead.
* update `system_install` to be a resource
* update `user_install` to be a resource
* update `script` resource
* update `python` resource
* update `global` resource
* update `rehash` resource
* create `plugin` resource
* create `pip` resource
* update integration tests
* add linting to CI
* delete all recipes
* delete matchers
* delete `chef_pyenv_recipe_helpers` library
* delete `chef_pyenv_mixin` library
* add support for Fedora, RedHat distros and OpenSUSE

## 0.2.0
* Add oracle linux support
* Update syntax for chef-client v13
* Update gems and dependencies
* Add integration tests on travis

## 0.1.4
* Updated deprecated methods used in attributes.rb

## 0.1.0

* Update default pyenv version to v0.4.0-20140516
* Add support for CentOS 6.5
* Install `make`, `build-essential`, `libssl-dev`, `zlib1g-dev`, `wget`,
  `curl`, and `llvm` on Debian machines

## 0.0.1

* Initial port of [chef-rbenv](https://github.com/fnichol/chef-rbenv)
