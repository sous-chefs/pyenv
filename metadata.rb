name             'pyenv'
maintainer       'Darwin D. Wu'
maintainer_email 'darwinwu67@gmail.com'
license          'Apache 2.0'
description      'Manages pyenv and its installed Python versions, also providing several LWRPs.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url       'https://github.com/darwin67/chef-pyenv/issues'
source_url       'https://github.com/darwin67/chef-pyenv'
version          '0.2.0'
chef_version     '>= 12.9' if respond_to?(:chef_version)

%w[centos ubuntu oracle].each do |os|
  supports os
end
