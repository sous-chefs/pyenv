# Upgrading to pyenv 5

The cookbook remains a custom-resource API. Existing `pyenv_install`, `pyenv_python`,
`pyenv_global`, `pyenv_local`, `pyenv_pip`, `pyenv_plugin`, `pyenv_rehash` and
`pyenv_script` declarations keep their names and defaults. Declare `pyenv_install`
before dependent resources, and manage one installation root per converge.

The major release retires unsupported operating-system versions. Use Debian 12 or
newer, RHEL-family 8 or newer, CentOS Stream 9 or newer, Amazon Linux 2023, or
openSUSE Leap 16. Ubuntu 20.04 remains available for ESM deployments; maintain the
appropriate Ubuntu Pro subscription and security updates. Fedora continues to use
the current rolling CI image.

Python version selection is still explicit in your resources. Test examples use
Python 3.12.16 on older supported systems and Python 3.15.2 on Fedora 45 or newer,
whose OpenSSL 4 headers require a compatible Python release. This does not change
interpreters requested by your cookbooks or replace global OpenSSL headers.
Python uninstall now removes an installed version and skips missing versions.

Maintainers should use `test/cookbooks/test` and the Policyfile named run lists.
The `default` Kitchen suite is a lightweight installation smoke test. System
installation verifies a second unchanged converge; the user suite exercises
requirements and uninstall transitions and verifies its final state.
