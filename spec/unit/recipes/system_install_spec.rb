#
# Cookbook:: chef-pyenv
# Spec:: system_install
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'pyenv::system_install' do
  DISTRIBUTIONS.each do |platform, versions|
    versions.each do |version|
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(platform: platform, version: version)
          .converge(described_recipe)
      end

      it 'includes the default recipe' do
        expect(chef_run).to include_recipe('pyenv')
      end

      it 'creates /etc/profile.d' do
        expect(chef_run).to create_directory('/etc/profile.d').with(
                              owner: 'root',
                              mode:  '0755'
                            )
      end

      it 'sets pyenv.sh' do
        expect(chef_run).to create_template('/etc/profile.d/pyenv.sh').with(
                              source: 'pyenv.sh.erb',
                              owner:  'root',
                              mode:   '0755'
                            )
      end
    end
  end
end
