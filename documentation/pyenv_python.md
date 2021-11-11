# `pyenv_python`

```ruby
pyenv_python '3.6.1' do
  user         # Optional: if passed, the user pyenv to install to
  environment  # Optional: pass environment variable to git resource
  pyenv_action # Optional: the action to perform, install, remove etc
  verbose      # Optional: print verbose output during python installation
end
```

Shorter example

```ruby
pyenv_python '3.6.1'
```
