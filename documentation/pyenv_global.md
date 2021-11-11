# `pyenv_global`

```ruby
pyenv_global '3.6.1' do
  user # Optional: if passed sets the users global version. Do not set, to set the systems global version
end
```

If a user is passed in to this resource it sets the global version for the user, under the users root_path (usually `~/.pyenv/version`), otherwise it sets the system global version.

| Name          | Type   | Default   | Description |
| ------------- | ------ | --------- | ----------- |
| pyenv_version | String |           |             |
| user          | String |           |             |
| prefix        | String | root_path |             |
