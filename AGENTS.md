# pyenv cookbook guidance

## Owner decision

* Full resource migration approved on 12 November 2026. Preserve all eight public resource names and their defaults.
* Keep root recipes and attributes absent. Test recipes belong under `test/cookbooks/test`.
* Use a feature PR first; regenerate the existing patch release as a major release after the migration merges. Do not hand-edit the release manifest on this branch.
* Retain Linux platform families. Ubuntu 20.04 remains in CI for Ubuntu Pro/ESM users; it is not treated as a standard-support release.

## Installation and build findings

* pyenv is installed from its upstream Git repository; Python interpreters are compiled by python-build.
* Follow the [upstream build prerequisites](https://github.com/pyenv/pyenv/wiki#suggested-build-environment). OpenSSL development headers provide Python SSL support; the obsolete `python-openssl` package is not a build prerequisite.
* Test Python 3.12 rather than the end-of-life Python 3.7 fixture. Ubuntu 20.04 lacks sufficiently new zstd for Python 3.14's optional compression module, so retain the compatible 3.12 test line.
* Current CI covers Debian, Ubuntu, RHEL derivatives, CentOS Stream, Amazon Linux, Fedora, Oracle and openSUSE. Retire obsolete image versions without replacing these families with Ubuntu-only coverage.
* Metadata retains Linux Mint as an Ubuntu-family consumer; it has no dedicated Dokken image. Scientific Linux is retired; its RHEL family remains covered by AlmaLinux, Rocky and Oracle.

## Resource and test constraints

* Declare `pyenv_install` before other resources. The existing converge-local root registry and single-root-per-converge behaviour remain unchanged.
* `pyenv_python :uninstall` must run only when the version exists. `pyenv_pip :uninstall` must skip an already absent individual package.
* ChefSpec steps into every resource and stubs filesystem/package command results at external boundaries.
* The default and system-install suites require two converges with zero updates on the second.
* The user-install suite deliberately reinstalls requirements and removes a package to exercise lifecycle transitions; it verifies the final state with one converge rather than claiming that this sequence is idempotent.
* Keep platform names identical across Kitchen files and CI. Use Dokken for Linux; the old generic macOS/Windows exec scaffold does not represent supported cookbook platforms.
* Native ARM Dokken images are available for local Docker. Never run these installation suites directly against the macOS host.
