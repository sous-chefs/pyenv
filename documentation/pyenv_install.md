# `pyenv_install`

Installs pyenv to either a user or system location.

```ruby
pyenv_install 'foo' do
  git_url      # URL of the plugin repo you want to checkout
  git_ref      # Optional: Git reference to checkout
  environment  # Optional: pass environment variable during pyenv installation
  update_pyenv # Optional: Keeps the git repo up to date
end
```

| Name         | Type            | Allowed Options                            | Default                              | Description                                            |
| ------------ | --------------- | ------------------------------------------ | ------------------------------------ | ------------------------------------------------------ |
| prefix_type  | String          | user system                                |                                      | Whether to install pyenv to a user or system directory |
| user         | String          |                                            | `root`                               | User directory to install pyenv to                     |
| group        | String,         |                                            | `user`                               | Group for the pyenv directories and files              |
| git_url      | String          |                                            | `https://github.com/pyenv/pyenv.git` |                                                        |
| git_ref      | String,         |                                            |                                      | `master`                                               |
| home_dir     | String          |                                            | user home                            |                                                        |
| prefix       | String          | `/usr/local/pyenv` or users home directory | Path to install pyenv to             |
| environment  | Hash            |                                            |                                      |                                                        |
| update_pyenv | `true`, `false` |                                            | false                                |
