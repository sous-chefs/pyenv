# pyenv cookbook guidance

## Owner decision

* Full resource migration approved on 12 November 2026. Preserve all eight public resource names and their defaults.
* Keep root recipes and attributes absent. Test recipes belong under `test/cookbooks/test`.
* Use a feature PR first; regenerate the existing patch release as a major release after the migration merges. Do not hand-edit the release manifest on this branch.
* Retain Linux platform families. Ubuntu 20.04 remains in CI for Ubuntu Pro/ESM users; it is not treated as a standard-support release.

## Installation and build findings

* pyenv is installed from its upstream Git repository; Python interpreters are compiled by python-build.
* Follow the [upstream build prerequisites](https://github.com/pyenv/pyenv/wiki#suggested-build-environment). OpenSSL development headers provide Python SSL support; the obsolete `python-openssl` package is not a build prerequisite.
* Use maintained Python fixtures rather than end-of-life Python 3.7. Retain the compatible 3.12 line on Ubuntu 20 and older supported systems; Fedora 45+ uses Python 3.15 for its OpenSSL 4 headers. This changes no resource Python default.
* Current CI covers Debian, Ubuntu, RHEL derivatives, CentOS Stream, Amazon Linux, Fedora, Oracle and openSUSE. Retire obsolete image versions without replacing these families with Ubuntu-only coverage.
* Metadata retains Linux Mint as an Ubuntu-family consumer; it has no dedicated Dokken image. Scientific Linux is retired; its RHEL family remains covered by AlmaLinux, Rocky and Oracle.

## Resource and test constraints

* Declare `pyenv_install` before other resources. The existing converge-local root registry and single-root-per-converge behaviour remain unchanged.
* `pyenv_python :uninstall` must run only when the version exists. `pyenv_pip :uninstall` must skip an already absent individual package.
* ChefSpec steps into every resource and stubs filesystem/package command results at external boundaries.
* The default and system-install suites require two converges with zero updates on the second.
* The user-install suite deliberately reinstalls requirements and removes a package to exercise lifecycle transitions; it verifies the final state with one converge rather than claiming that this sequence is idempotent.
* Keep platform names identical across Kitchen files and CI. Use Dokken for Linux; the old generic macOS/Windows exec scaffold does not represent supported cookbook platforms.
* Leap 16 uses the official `opensuse/leap:16.0` image with systemd/gzip/tar installed, matching the Apache cookbook's existing setup; no `dokken/opensuse-leap-16` image is published.
* Debian 13 no longer supplies `/bin/systemd`; use `/usr/lib/systemd/systemd`. Leap 16's development pattern installs `zlib-ng-compat-devel`, which conflicts with explicitly installing legacy `zlib-devel`.
* Minimal Amazon Linux images lack tar even after compiler installation. Install tar/gzip/patch explicitly as Python source-build prerequisites.
* File-change protection runs on opened, reopened and synchronize events. PR body edits do not change files; the upstream action incorrectly treats the editing actor as the PR author and otherwise rejects a bot's `pull_request` edit event. Keep title validation on edits and retain every code-change protection event.
* Native ARM Dokken images are available for local Docker. Never run these installation suites directly against the macOS host.
* Completion repair on 12 November: Fedora 45 defaults to OpenSSL4 development headers, which fail
  Python 3.12 SSL compilation. Its installed headers conflict with openssl3-devel; do not replace
  global development headers. Use current Python 3.15.2 for that Fedora test fixture and retain
  Python 3.12.16 elsewhere for Ubuntu20 compatibility. Keep public resource defaults unchanged.
  Refresh Fedora package metadata before prerequisites to avoid the observed stale Git candidate.
  Verifiers derive the expected version from the actual target OS, so the same expectations apply
  to every documented Kitchen driver rather than a Docker-only verifier input.
* The official Leap16 image lacks sudo, while system/user verifier commands explicitly use it.
  Install sudo in the test image; do not remove those assertions or platform coverage.
* The VM lab is outside this completion task and must remain untouched. Use isolated Docker only.
* Focused completion evidence: Fedora 45 native ARM system installation built Python 3.15.2 with
  existing OpenSSL 4 headers and completed a second converge with zero updates. Leap 16 user
  installation built Python 3.12.16 and passed every pip, virtualenv, ownership and sudo assertion.
  Public resource defaults and all 12 CI platform entries remain unchanged.
