# pyenv_script

Runs a pyenv aware script.

```ruby
pyenv_script 'foo' do
  code          # Script code to run
  pyenv_version # pyenv version to run the script against
  environment   # Optional: Environment to setup to run the script
  user          # Optional: User to run as
  umask         # Optional: the umask to set before running the script
  group         # Optional: Group to run as
  path          # Optional: Path to search for commands
  returns       # Optional: Expected return code
end
```
