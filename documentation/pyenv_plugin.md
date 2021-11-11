# `pyenv_plugin`

Installs a pyenv plugin.

```ruby
pyenv_plugin 'virtualenv' do
  git_url     # Git URL of the plugin
  git_ref     # Git reference of the plugin
  environment # Optional: pass environment variables to git resource
  user        # Optional: if passed installs to the users pyenv. Do not set, to set installs to the system pyenv.
end
```
