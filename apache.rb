dep 'apache listening', :port do
  port.default! 80
  requires_when_unmet 'apache2.managed',
                      'apache port configured'.with(port)
  met? { shell? "sudo lsof -i :'#{port}' | grep apache2" }
  meet { sudo 'service apache2 start' }
end

dep 'apache2.managed' do
  met? { `dpkg -s apache2 2>&1`.include?("\nStatus: install ok installed\n") }
end

dep 'apache site enabled', :site_name do
  requires_when_unmet 'apache2.managed',
                      "#{site_name}.vhost"
  met? { "/etc/apache2/sites-enabled/#{site_name}.conf".p.exists? }
  meet { log_shell "Enabling apache site '#{site_name}'", "a2ensite '#{site_name}'", :sudo => true }
  after { sudo 'service apache2 reload' }
end

dep 'apache site disabled', :site_name do
  requires_when_unmet 'apache2.managed'
  met? { !"/etc/apache2/sites-enabled/#{site_name}.conf".p.exists? }
  meet { log_shell "Disabling apache site '#{site_name}'", "a2dissite '#{site_name}'", :sudo => true }
  after { sudo 'service apache2 reload' }
end

dep 'apache module enabled', :module_name do
  requires_when_unmet 'apache2.managed'
  met? { "/etc/apache2/mods-enabled/#{module_name}.load".p.exists? }
  meet { log_shell "Enabling apache module '#{module_name}'", "a2enmod '#{module_name}'", :sudo => true }
  after { sudo 'service apache2 reload' }
end

dep 'apache module disabled', :module_name do
  requires_when_unmet 'apache2.managed'
  met? { !"/etc/apache2/mods-disabled/#{module_name}.load".p.exists? }
  meet { log_shell "Disabling apache module '#{module_name}'", "a2dismod '#{module_name}'", :sudo => true }
  after { sudo 'service apache2 reload' }
end

dep 'apache default port file removed' do
  requires 'apache2.managed'
  config_file = '/etc/apache2/ports.conf'.p
  met? { !config_file.grep /README\.Debian\.gz/ }
  meet {
    sudo "rm '#{config_file}'"
    sudo "touch '#{config_file}'"
  }
  after { sudo 'service apache2 reload' }
end

dep 'apache default configuration removed' do
  requires 'apache default port file removed',
           'apache site disabled'.with('000-default')
end

dep 'apache port configured', :port do
  requires 'apache default port file removed'
  config_file = '/etc/apache2/ports.conf'.p
  met? { shell? "grep -x 'Listen #{port}' '#{config_file}'" }
  meet { sudo "tee -a '#{config_file}'", :input => "Listen #{port}\nNameVirtualHost *:#{port}\n" }
  after { sudo 'service apache2 reload' }
end

meta :vhost do
  accepts_value_for :webroot
  accepts_value_for :port, 80
  accepts_value_for :hostname
  accepts_value_for :sitename, :basename

  template {
    requires 'apache default configuration removed',
             'apache listening'.with(:port => port)

    require 'erb'

    def destination
      "/etc/apache2/sites-available/#{sitename}.conf".p
    end

    def template_name
      if "#{__FILE__.p.parent}/apache/#{hostname}.erb".p.exists?
        hostname
      else
        "vhost"
      end
    end

    def source
      template = "#{__FILE__.p.parent}/apache/#{template_name}.erb"
      log "Using config template #{template}"
      template.p
    end

    def configuration
      @erb ||= ERB.new(source.read).result(binding)
    end

    met? { destination.exists? && destination.read == configuration }
    meet { sudo "tee '#{destination}'", :input => configuration }
    after { sudo 'service apache2 restart' }
  }
end
