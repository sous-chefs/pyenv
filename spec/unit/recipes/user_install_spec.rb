#
# Cookbook:: pyenv
# Spec:: user_install
#
# Copyright:: 2018, Darwin D. Wu <darwinwu67@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'

describe 'test::user_install' do
  DISTROS.each do |platform, versions|
    versions.each do |version|
      context "on #{platform} #{version}" do
        cached(:chef_run) do
          ChefSpec::ServerRunner.new(platform: platform, version: version)
                                .converge(described_recipe)
        end

        it 'installs pyenv globally' do
          expect(chef_run).to install_pyenv_user_install('vagrant')
        end

        it 'installs the specified python version' do
          expect(chef_run).to install_pyenv_python('3.6.1').with(user: 'vagrant')
        end

        it 'sets the specified python version as global default' do
          expect(chef_run).to create_pyenv_global('3.6.1').with(user: 'vagrant')
        end

        it 'installs the virtualenv plugin' do
          expect(chef_run).to install_pyenv_plugin('virtualenv').with(
            user: 'vagrant',
            git_url: 'https://github.com/pyenv/pyenv-virtualenv'
          )
        end

        it 'installs a python package with pip' do
          expect(chef_run).to install_pyenv_pip('requests').with(
            user: 'vagrant',
            version: '2.18.3'
          )
        end

        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end
      end
    end
  end
end
