# git repository containing pyenv
default['pyenv']['git_url'] = 'https://github.com/pyenv/pyenv.git'
default['pyenv']['git_ref'] = 'master'

default['pyenv']['prerequisites'] = case node['platform_family']
                                    when 'debian'
                                      %w(make build-essential libssl-dev zlib1g-dev git-core grep libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm)
                                    when 'rhel', 'fedora', 'amazon'
                                      %w(libffi-devel zlib-devel bzip2-devel readline-devel sqlite-devel wget curl llvm ncurses-devel openssl-devel redhat-rpm-config git grep)
                                    when 'suse'
                                      %w(git git-core zlib-devel bzip2 libbz2-devel readline-devel sqlite3 sqlite3-devel libopenssl-devel xz xz-devel)
                                    when 'mac_os_x'
                                      %w(git readline xz)
                                    end
