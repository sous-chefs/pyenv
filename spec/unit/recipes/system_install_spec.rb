#
# Cookbook:: pyenv
# Spec:: system_install
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

describe 'test::system_install' do
  DISTROS.each do |platform, versions|
    versions.each do |version|
      context "on #{platform} #{version}" do
        let(:resources) do
          [
            :pyenv_system_install
          ]
        end

        cached(:chef_run) do
          ChefSpec::ServerRunner.new(platform: platform, version: version, step_into: resources)
            .converge(described_recipe)
        end


        it 'installs pyenv globally' do
          expect(chef_run).to install_pyenv_system_install('system')
        end

        it 'installs the specified python version' do
          expect(chef_run).to install_pyenv_python('3.6.1')
        end

        it 'sets the specified python version as global default' do
          expect(chef_run).to create_pyenv_global('3.6.1')
        end

        it 'installs the virtualenv plugin' do
          expect(chef_run).to install_pyenv_plugin('virtualenv').with(git_url: 'https://github.com/pyenv/pyenv-virtualenv')
        end

        it 'installs a python package with pip' do
          expect(chef_run).to install_pyenv_pip('requests').with(version: '2.18.1')
        end

        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end

        context 'resource' do
          it 'creates /etc/profile.d' do
            expect(chef_run).to create_directory('/etc/profile.d')
          end

          it 'creates pyenv.sh' do
            expect(chef_run).to create_template('/etc/profile.d/pyenv.sh').with(
                                  cookbook: 'pyenv',
                                  source:   'pyenv.sh',
                                  owner:    'root',
                                  mode:     '0755',
                                  variables: { global_prefix: '/usr/local/pyenv' }
                                )
          end
        end
      end
    end
  end
end
