# pyenv_local

Sets the Python version for a working directory after `pyenv_install` has run.

```ruby
pyenv_local '3.12.12' do
  path '/srv/example'
  user 'example'
end
```

The directory must exist. The resource writes `.python-version` only when the
selected version differs. `python_version` defaults to the resource name; `path`
is required and `user` is optional.
