#
# Cookbook:: pyenv
# Resource:: pip
#
# Author:: Darwin D. Wu <darwinwu67@gmail.com>
#
# Copyright:: 2018, Darwin D. Wu
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
#
provides :pyenv_pip

property :package_name, String, name_property: true
property :version,      String
property :user,         String
property :reinstall,    [true, false], default: false

action :install do
  opt = new_resource.reinstall ? '-I' : ''
  command = if new_resource.version
              "pip install #{opt} #{new_resource.package_name}==#{new_resource.version}"
            else
              "pip install #{opt} #{new_resource.package_name}"
            end

  pyenv_script new_resource.package_name do
    code command
    user new_resource.user if new_resource.user
  end
end

action :uninstall do
  command = "pip uninstall #{new_resource.package_name}"

  pyenv_script new_resource.package_name do
    code command
    user new_resource.user if new_resource.user
  end
end
