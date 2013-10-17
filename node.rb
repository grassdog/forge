dep 'npm' do
  requires 'nodejs.managed'

  met? { in_path? 'npm' }
  meet {
    log_shell 'Run npm install.sh', 'curl http://npmjs.org/install.sh | clean=no sh'
  }
end

dep "nodejs.managed" do
  provides "node"
end

