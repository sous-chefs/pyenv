provides :pyenv_install
# provides :pyenv_user_install
# provides :pyenv_system_install
unified_mode true

property :prefix_type,
          String,
          equal_to: %w( user system ),
          name_property: true,
          description: 'Whether to install pyenv to a user or system directory.'

property :user,
          String,
          default: 'root',
          description: 'User directory to install pyenv to.'

property :group, String,
          default: lazy { user },
          description: 'Group for the pyenv directories and files.'

property :git_url,
          String,
          default: 'https://github.com/pyenv/pyenv.git'

property :git_ref,
          String,
          default: 'master'

property :prefix,
          String,
          default: lazy {
            if prefix_type == 'user'
              ::File.join(home_dir, '.pyenv')
            else
              '/usr/local/pyenv'
            end
          },
          description: 'Path to install pyenv to'

property :environment,
          Hash

property :update_pyenv,
          [true, false],
          default: false

action :install do
  node.run_state['sous-chefs'] ||= {}
  node.run_state['sous-chefs']['pyenv'] ||= {}
  node.run_state['sous-chefs']['pyenv']['root_path'] ||= {}
  node.run_state['sous-chefs']['pyenv']['root_path']['prefix'] ||= new_resource.prefix

  build_essential 'build packages'
  package pyenv_prerequisites

  directory '/etc/profile.d' do
    owner 'root'
    mode '0755'
  end

  template '/etc/profile.d/pyenv.sh' do
    cookbook 'pyenv'
    source   'pyenv.sh'
    owner    'root'
    mode     '0755'
    variables(
      global_prefix: node.run_state['sous-chefs']['pyenv']['root_path']['prefix']
    )
  end

  git new_resource.prefix do
    repository new_resource.git_url
    revision   new_resource.git_ref
    user       new_resource.user
    group      new_resource.group
    depth      1
    action     new_resource.update_pyenv ? :sync : :checkout
    environment(new_resource.environment)
    notifies :run, 'ruby_block[Add pyenv to PATH]', :immediately
  end

  %w(plugins shims versions).each do |d|
    directory "#{new_resource.prefix}/#{d}" do
      owner new_resource.user
      group new_resource.group
      mode '0755'
    end
  end

  # Initialize pyenv
  ruby_block 'Add pyenv to PATH' do
    block do
      ENV['PATH'] = "#{new_resource.prefix}/shims:#{new_resource.prefix}/bin:#{ENV['PATH']}"
    end
    action :nothing
  end

  execute 'Initialize pyenv' do
    command %(PATH="#{new_resource.prefix}/bin:$PATH" pyenv init -)
    environment('PYENV_ROOT' => new_resource.prefix)
    action :nothing
    subscribes :run, "git[#{new_resource.prefix}]", :immediately
  end
end

action_class do
  include Chef::Pyenv::ScriptHelpers
end
