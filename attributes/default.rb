# git repository containing pyenv
default['pyenv']['git_url'] = 'https://github.com/pyenv/pyenv.git'
default['pyenv']['git_ref'] = 'master'

# upgrade action strategy
default['pyenv']['upgrade'] = 'none'

# extra system-wide tunables
default['pyenv']['root_path'] = '/usr/local/pyenv'

# a list of user hashes, each an isolated per-user pyenv installation
default['pyenv']['user_installs'] = []

# list of additional Pythons that will be installed
default['pyenv']['pythons']      = []
default['pyenv']['user_pythons'] = []

# whether to create profile.d shell script
default['pyenv']['create_profiled'] = true

if platform?('redhat', 'centos', 'fedora', 'amazon', 'scientific', 'oracle')
  default['pyenv']['install_pkgs'] = %w[
    bzip2 bzip2-devel
    git
    grep
    patch
    readline-devel
    sqlite sqlite-devel
    zlib-devel
    openssl-devel
  ]
  default['pyenv']['user_home_root'] = '/home'
elsif platform?('debian', 'ubuntu', 'suse')
  default['pyenv']['install_pkgs'] = %w[
    make
    build-essential
    libssl-dev
    zlib1g-dev
    git-core
    grep
    libbz2-dev
    libreadline-dev
    libsqlite3-dev
    wget
    curl
    llvm
  ]
  default['pyenv']['user_home_root'] = '/home'
elsif platform?('mac_os_x')
  default['pyenv']['install_pkgs']   = %w[git readline]
  default['pyenv']['user_home_root'] = '/Users'
elsif platform?('freebsd')
  default['pyenv']['install_pkgs']   = %w[git]
  default['pyenv']['user_home_root'] = '/usr/home'
end
