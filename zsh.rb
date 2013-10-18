dep 'zsh', :username do
  username.default!(shell('whoami'))
  requires 'zsh.shell_setup'
  met? {
    if username === shell('whoami')
      shell("echo $SHELL") === which('zsh')
    else
      shell("sudo su - '#{username}' -c 'echo $SHELL'") == which('zsh')
    end
  }
  meet { sudo("chsh -s '#{which('zsh')}' #{username}") }
end

dep 'zsh.shell_setup' do
  requires 'zsh.managed'
end

dep 'zsh.managed'
