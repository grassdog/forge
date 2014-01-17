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

dep 'wunder.raygrasso.com.apache_rails'

dep 'wunder.raygrasso.com.vhost' do
  webroot "/var/www/wunder.raygrasso.com"
  hostname "wunder.raygrasso.com"
end

dep 'wunder collect script installed' do
  requires 'wunder.raygrasso.com.apache_rails'

  met? { shell? "test -x /usr/local/bin/wunder_collect" }
  meet {
    render_erb 'wunder/wunder_collect.erb', :to => '/usr/local/bin/wunder_collect', :perms => '755', :sudo => true
  }
end

dep 'wunder collect.crontab' do
  schedule "0 * * * *"
  command "/bin/bash -l -c 'cd /var/www/wunder.raygrasso.com/current && bundle exec rake RAILS_ENV=production db:collect:all >> /var/www/wunder.raygrasso.com/shared/cron_logs/backup_cron.log'"
end

dep 'wunder backup script installed' do
  requires 's3cmd configured',
           'wunder.raygrasso.com.apache_rails'

  met? { shell? "test -x /usr/local/bin/wunder_s3_backup" }
  meet {
    render_erb 'wunder/wunder_s3_backup.erb', :to => '/usr/local/bin/wunder_s3_backup', :perms => '755', :sudo => true
  }
end

dep 'wunder backup.crontab' do
  schedule "5 8 * * 6"
  command "/usr/local/bin/wunder_s3_backup >> /var/www/wunder.raygrasso.com/shared/cron_logs/mongo_backup.log"
end

dep 'wunder crontab configured' do
  requires 'wunder collect script installed',
           'wunder collect.crontab',
           'wunder backup script installed',
           'wunder backup.crontab'
end



