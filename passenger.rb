dep 'passenger.2.0.0.gem' do
  gem_name 'passenger'
  ruby_version '2.0.0'
  requires '2.0.0.chruby'
  system_wide true
end

dep 'passenger apache' do
  requires 'passenger apache install',
           'passenger apache config'#,
           # 'apache module enabled'.with(module_name: 'passenger')
end

dep 'passenger apache install' do
  requires 'apache2-mpm-prefork.managed',
           'apache2-prefork-dev.managed',
           'passenger.2.0.0.gem'

  met? { "/opt/rubies/2.0.0-p247/lib/ruby/gems/2.0.0/gems/passenger-4.0.20/buildout/apache2/mod_passenger.so".p.exists? }
  meet { "chruby-exec 2.0.0 -- sudo passenger-install-apache2-module --auto" }
end

dep 'passenger apache config' do
  requires 'passenger apache install'

  met? { "/etc/apache2/apache2.conf".p.grep /LoadModule passenger_module/ }
  meet {
    sudo "echo \"\n# Passenger config\" >> /etc/apache2/apache2.conf"
    sudo "echo \"LoadModule passenger_module /opt/rubies/2.0.0-p247/lib/ruby/gems/2.0.0/gems/passenger-4.0.20/buildout/apache2/mod_passenger.so\" >> /etc/apache2/apache2.conf"
    sudo "echo \"PassengerRoot /opt/rubies/2.0.0-p247/lib/ruby/gems/2.0.0/gems/passenger-4.0.20\" >> /etc/apache2/apache2.conf"
    sudo "echo \"PassengerDefaultRuby /opt/rubies/2.0.0-p247/bin/ruby\" >> /etc/apache2/apache2.conf"
  }
  after { sudo 'service apache2 restart' }
end

dep 'apache2-mpm-prefork.managed' do
  met? { `dpkg -s apache2-mpm-prefork 2>&1`.include?("\nStatus: install ok installed\n") }
end
dep 'apache2-prefork-dev.managed' do
  met? { `dpkg -s apache2-prefork-dev 2>&1`.include?("\nStatus: install ok installed\n") }
end


