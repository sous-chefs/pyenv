# frozen_string_literal: true
require 'chefspec'
require 'chefspec/berkshelf'

DISTROS = {
  'debian' => ['8.10', '9.4'],
  'ubuntu' => ['14.04', '16.04', '18.04'],
  'centos' => ['6.9', '7.4.1708'],
  'amazon' => ['2017.12'],
  'oracle' => ['7.4'],
  'fedora' => ['27'],
  'opensuse' => ['42.3']
}

at_exit { ChefSpec::Coverage.report! }
