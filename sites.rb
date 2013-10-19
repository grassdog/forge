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
