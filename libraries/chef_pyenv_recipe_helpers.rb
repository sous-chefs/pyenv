class Chef
  module Pyenv
    module RecipeHelpers
      def build_upgrade_strategy(strategy)
        if strategy.nil? || strategy == false
          'none'
        else
          strategy
        end
      end

      def mac_with_no_homebrew
        node['platform'] == 'mac_os_x' &&
          Chef::Platform.find_provider_for_node(node, :package) !=
          Chef::Provider::Package::Homebrew
      end

      def install_pyenv_pkg_prereqs
        return if mac_with_no_homebrew

        node['pyenv']['install_pkgs'].each { |pkg| package pkg }
      end

      def install_or_upgrade_pyenv(opts = {})
        git_deploy_pyenv opts
        initialize_pyenv opts
      end

      private

      def git_deploy_pyenv(opts)
        git_exec_action = opts[:upgrade_strategy] == 'none' ? :checkout : :sync

        git opts[:pyenv_prefix] do
          repository  opts[:git_url]
          reference   opts[:git_ref]
          user        opts[:user]  if opts[:user]
          group       opts[:group] if opts[:group]

          action      git_exec_action
        end
      end

      def initialize_pyenv(opts)
        prefix = opts[:pyenv_prefix]
        init_env = opts[:user] ? { 'USER' => opts[:user], 'HOME' => opts[:home_dir] } : {}
        bash "Initialize pyenv (#{opts[:user] || 'system'})" do
          code %{PATH="#{prefix}/bin:$PATH" pyenv init -}
          environment({ 'PYENV_ROOT' => prefix }.merge(init_env))
          user  opts[:user]   if opts[:user]
          group opts[:group]  if opts[:group]
        end

        log "pyenv-post-init-#{opts[:user] || 'system'}"
      end
    end
  end
end
