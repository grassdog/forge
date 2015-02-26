meta :apache_site do
  accepts_value_for :sitename, :basename
  accepts_value_for :username

  template {
    requires "apache_site_dir".with(sitename: sitename, username: username),
             "apache site enabled".with(site_name: sitename)
  }
end

dep 'apache_site_dir', :sitename, :username do
  username.default!(shell('whoami'))

  met? { "/var/www/#{sitename}".p.exists? }
  meet {
    sudo "mkdir -p /var/www/#{sitename}"
    sudo "mkdir -p /var/www/#{sitename}/public_html"
    sudo "mkdir -p /var/www/#{sitename}/logs"
    sudo "chown -R #{username}:#{username} '/var/www/#{sitename}'"
  }
end

meta :apache_rails do
  accepts_value_for :sitename, :basename
  accepts_value_for :username

  template {
    requires "apache_rails_dir".with(sitename: sitename, username: username),
             "apache site enabled".with(site_name: sitename)
  }
end

dep 'apache_rails_dir', :sitename, :username do
  username.default!(shell('whoami'))

  met? { "/var/www/#{sitename}".p.exists? }
  meet {
    sudo "mkdir -p /var/www/#{sitename}/shared/config"
    sudo "mkdir -p /var/www/#{sitename}/shared/logs"
    sudo "touch /var/www/#{sitename}/shared/config/database.yml"
    sudo "touch /var/www/#{sitename}/shared/config/env.rb"
    sudo "chmod 600 /var/www/#{sitename}/shared/config/database.yml"
    sudo "chmod 600 /var/www/#{sitename}/shared/config/env.rb"
    sudo "chown -R #{username}:#{username} '/var/www/#{sitename}'"
  }
end

dep 'raygrasso.com.apache_site'

dep 'raygrasso.com.vhost' do
  webroot "/var/www/raygrasso.com"
  hostname "raygrasso.com"
end

dep 'strangemadness.com.apache_site'

dep 'strangemadness.com.vhost' do
  webroot "/var/www/strangemadness.com"
  hostname "strangemadness.com"
end

dep 'subscriber-scripts' do
  requires 'feed-subscribers.php.homefile',
           'show-subscribers.homefile'

end

meta 'homefile' do
  template {
    def filepath
      "~/#{basename}"
    end

    met? {
      filepath.p.exist?
    }

    meet {
      log_shell "Installing file", "cp #{__FILE__.p.parent}/files/#{basename} #{filepath}"
    }
  }
end

dep 'feed-subscribers.php.homefile'
dep 'show-subscribers.homefile'

