name             'pyenv'
maintainer       'Darwin D. Wu'
maintainer_email 'darwinwu67@gmail.com'
license          'Apache-2.0'
description      'Manages pyenv and its installed Python versions.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url       'https://github.com/darwin67/chef-pyenv/issues'
source_url       'https://github.com/darwin67/chef-pyenv'
version          '1.0.0'
chef_version     '>= 12.9' if respond_to?(:chef_version)

%w(
  ubuntu
  linuxmint
  debian
  redhat
  centos
  fedora
  amazon
  scientific
  opensuse
  opensuseleap
  oracle
).each do |os|
  supports os
end
