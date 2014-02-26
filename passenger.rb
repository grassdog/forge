dep 'passenger apache' do
  requires '2.1.1.passenger_apache',
           'apache module enabled'.with(module_name: 'rewrite')
end

dep '2.1.1.passenger_apache' do
  version '4.0.37'
  ruby_version '2.1.1'
end

meta 'passenger_apache' do
  accepts_value_for :version, '4.0.37'
  accepts_value_for :ruby_version, :basename

  template {
    def ruby_major_version
      _, major = *ruby_version.match(/(\d+\.\d+\.)\d+/)
      "#{major}0"
    end

    requires 'passenger_apache install'.with(version: version,
                                             ruby_version: ruby_version,
                                             ruby_major_version: ruby_major_version),
             'passenger_apache config'.with(version: version,
                                            ruby_version: ruby_version,
                                            ruby_major_version: ruby_major_version)
  }
end

dep 'passenger_apache install', :version, :ruby_version, :ruby_major_version do
  requires 'apache2-mpm-prefork.managed',
           'apache2-prefork-dev.managed',
           'gem'.with(gem_name: 'passenger',
                      ruby_version: ruby_version,
                      version: version)

  met? { "/opt/rubies/#{ruby_version}/lib/ruby/gems/#{ruby_major_version}/gems/passenger-#{version}/buildout/apache2/mod_passenger.so".p.exists? }
  meet {
    shell "chruby-exec #{ruby_version} -- /opt/rubies/#{ruby_version}/bin/passenger-install-apache2-module --auto"
  }
end

dep 'passenger_apache config', :version, :ruby_version, :ruby_major_version do
  def config_file
    "/etc/apache2/apache2.conf"
  end

  def config_text
    <<-EOF

# Passenger config for version #{version} on ruby #{ruby_version}
LoadModule passenger_module /opt/rubies/#{ruby_version}/lib/ruby/gems/#{ruby_major_version}/gems/passenger-#{version}/buildout/apache2/mod_passenger.so
<IfModule mod_passenger.c>
  PassengerRoot /opt/rubies/#{ruby_version}/lib/ruby/gems/#{ruby_major_version}/gems/passenger-#{version}
  PassengerDefaultRuby /opt/rubies/#{ruby_version}/bin/ruby
</IfModule>
# end Passenger config
EOF
  end

  setup {
    unmeetable! "This dep has to be run as root." unless shell('whoami') == 'root'
  }

  met? { config_file.p.read.include? config_text }

  meet {
    content = config_file.p.read
    content.gsub! /# Passenger config for version.+# end Passenger config/m, ""
    content += config_text

    config_file.p.write content
  }
  after { sudo 'service apache2 restart' }
end

dep 'apache2-mpm-prefork.managed' do
  met? { `dpkg -s apache2-mpm-prefork 2>&1`.include?("\nStatus: install ok installed\n") }
end

dep 'apache2-prefork-dev.managed' do
  met? { `dpkg -s apache2-prefork-dev 2>&1`.include?("\nStatus: install ok installed\n") }
end

