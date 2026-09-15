require 'shellwords'

unified_mode true

property :package_name,
          String,
          name_property: true

property :virtualenv,
          String

property :version,
          String

property :user,
          String

property :umask,
          [String, Integer]

property :options,
          String

property :requirement,
          [true, false],
          default: false

property :editable,
          [true, false],
          default: false

action :install do
  install_mode = if new_resource.requirement
                   '--requirement'
                 elsif new_resource.editable
                   '--editable'
                 else
                   ''
                 end

  install_target = if new_resource.version
                     "#{new_resource.package_name}==#{new_resource.version}"
                   else
                     new_resource.package_name
                   end

  pip_args = ['install', *Shellwords.split(new_resource.options.to_s), install_mode, install_target].reject { |arg| arg.to_s.empty? }

  # without virtualenv, install package with system's pip
  pip_executable = new_resource.virtualenv ? "#{new_resource.virtualenv}/bin/pip" : 'pip'
  command = Shellwords.join([pip_executable, *pip_args])

  pyenv_script new_resource.package_name do
    code command
    user new_resource.user
    umask new_resource.umask
    only_if { require_install? }
  end
end

action :upgrade do
  upgrade_target = if new_resource.version
                     "#{new_resource.package_name}==#{new_resource.version}"
                   else
                     new_resource.package_name.to_s
                   end

  pip_args = ['install', '--upgrade', *Shellwords.split(new_resource.options.to_s), upgrade_target].reject { |arg| arg.to_s.empty? }

  # without virtualenv, upgrade package with system's pip
  pip_executable = new_resource.virtualenv ? "#{new_resource.virtualenv}/bin/pip" : 'pip'
  command = Shellwords.join([pip_executable, *pip_args])

  pyenv_script new_resource.package_name do
    code command
    user new_resource.user
    umask new_resource.umask
    only_if { require_upgrade? }
  end
end

action :uninstall do
  uninstall_mode = if new_resource.requirement
                     '--requirement'
                   else
                     ''
                   end

  pip_args = ['uninstall', '--yes', *Shellwords.split(new_resource.options.to_s), uninstall_mode, new_resource.package_name].reject { |arg| arg.to_s.empty? }

  # without virtualenv, uninstall package with system's pip
  pip_executable = new_resource.virtualenv ? "#{new_resource.virtualenv}/bin/pip" : 'pip'
  command = Shellwords.join([pip_executable, *pip_args])

  pyenv_script new_resource.package_name do
    code command
    user new_resource.user
    umask new_resource.umask
  end
end

action_class do
  include PyEnv::Cookbook::ScriptHelpers

  def require_install?
    current_version = get_current_version
    return true unless current_version

    unless new_resource.version
      Chef::Log.debug("already installed: #{new_resource.package_name} #{current_version}")
      return false
    end

    is_different_version?(current_version)
  end

  def require_upgrade?
    current_version = get_current_version
    return true unless current_version

    is_different_version?(current_version)
  end

  def get_current_version
    current_version = nil
    show = pip_command('show', new_resource.package_name).stdout
    show.split(/\n+/).each do |line|
      current_version = line.split(/\s+/)[1] if line.start_with?('Version:')
    end
    Chef::Log.debug("current_version: #{new_resource.package_name} #{current_version}")
    unless current_version
      Chef::Log.debug("not installed: #{new_resource.package_name}")
    end
    current_version
  end

  def is_different_version?(current_version)
    if current_version != new_resource.version
      Chef::Log.debug("different version installed: #{new_resource.package_name} current=#{current_version} candidate=#{new_resource.version}")
      true
    else
      Chef::Log.debug("same version installed: #{new_resource.package_name} #{current_version}")
      false
    end
  end
end
