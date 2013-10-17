dep 'bootstrap' do
  requires 'system', 'users', 'core software', 'server software', 'ruby development', 'passenger apache'
end

dep 'core software' do
  requires {
    on :linux, 'vim.bin', 'curl.bin', 'tree.bin', 'wget.bin', 'htop.bin', 'lsof.bin',
               'traceroute.bin', 'iotop.bin', 'jnettop.bin', 'tmux.bin', 'nmap.bin', 'pv.bin'
  }
end

dep 'server software' do
  requires {
    on :linux, 'postgres.managed'.with(version: '9.3'), 'mongodb', 'apache2.managed'#, 'npm'
  }
end

dep 'users' do
  def key
    "#{__FILE__.p.parent}/keys/key.pub".p
  end

  requires 'user setup for provisioning'.with(username: 'ray', key: key.read, home_dir_base: '/home'),
           'user setup for provisioning'.with(username: 'deploy', key: key.read, home_dir_base: '/home')
end
