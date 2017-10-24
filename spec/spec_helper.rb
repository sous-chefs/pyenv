require 'chefspec'
require 'chefspec/berkshelf'

DISTRIBUTIONS = {
  'ubuntu' => ['14.04', '16.04'],
  'centos' => ['6.9', '7.3.1611']
}

at_exit { ChefSpec::Coverage.report! }
