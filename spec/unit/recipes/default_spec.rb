#
# Cookbook:: chef-pyenv
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'pyenv::default' do
  DISTRIBUTIONS.each do |platform, versions|
    versions.each do |version|
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(platform: platform, version: version)
          .converge(described_recipe)
      end

      it 'converges successfully' do
        # expect(Chef::Recipe).to receive(:include).with(Chef::Pyenv::RecipeHelpers)
        expect { chef_run }.to_not raise_error
      end
    end
  end
end
