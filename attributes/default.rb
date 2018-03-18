# git repository containing pyenv
default['pyenv']['git_url'] = 'https://github.com/pyenv/pyenv.git'
default['pyenv']['git_ref'] = 'master'

default['pyenv']['prerequisites'] = case node['platform_family']
                                    when 'rhel', 'fedora', 'amazon', 'scientific', 'oracle'
                                      %w(bzip2 bzip2-devel git grep patch readline-devel sqlite sqlite-devel zlib-devel openssl-devel)
                                    when 'debian', 'ubuntu'
                                      %w(make build-essential libssl-dev zlib1g-dev git-core grep libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm)
                                    when 'suse'
                                      %w(git git-core zlib-devel bzip2 libbz2-devel readline-devel sqlite3 sqlite3-devel libopenssl-devel xz xz-devel)
                                    when 'mac_os_x'
                                      %w(git readline xz)
                                    end
