# Need to log out after this is run so that local effects kick in
dep 'stage1' do
  requires 'set.locale'
end

# To be run as root
dep 'stage2' do
  requires 'system', 'users', 'core software',
           'server software', 'ruby environment',
           'passenger apache'

  setup {
    unmeetable! "This dep has to be run as root." unless shell('whoami') == 'root'
  }
end

# To be run as the deploy user
dep 'stage3' do
  requires 'raygrasso.com.apache_site',
           'strangemadness.com.apache_site',
           'wunder.raygrasso.com.apache_rails',
           'wunder crontab configured',
           'summate'
end



dep 'system' do
  requires 'hostname',
           'timezone',
           'secured ssh logins',
           'lax host key checking',
           'admins can sudo',
           'tmp cleaning grace period',
           'ufw ssh and http only',
           'fail2ban apache enabled'
  setup {
    unmeetable! "This dep has to be run as root." unless shell('whoami') == 'root'
  }
end


dep 'core software' do
  requires {
    on :linux, 'vim.bin', 'curl.bin', 'tree.bin', 'wget.bin', 'htop.bin', 'lsof.bin',
               'traceroute.bin', 'iotop.bin', 'jnettop.bin', 'tmux.bin', 'nmap.bin', 'pv.bin'
  }
end

dep 'server software' do
  requires {
    on :linux, 'postgres installed', 'mongodb', 'apache2.managed', 'nodejs'
  }
end

dep 'users' do
  def key
    "#{__FILE__.p.parent}/keys/key.pub".p
  end

  requires 'user setup for provisioning'.with(username: 'ray', key: key.read, home_dir_base: '/home'),
           'user setup for provisioning'.with(username: 'deploy', key: key.read, home_dir_base: '/home')
end
