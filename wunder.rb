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
  command "/bin/bash -l -c 'cd /var/www/wunder.raygrasso.com/current && bundle exec rake RAILS_ENV=production trawl:add_new:all >> /var/www/wunder.raygrasso.com/shared/cron_logs/collect.log 2>&1'"
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
  command "/usr/local/bin/wunder_s3_backup >> /var/www/wunder.raygrasso.com/shared/cron_logs/mongo_backup.log 2>&1"
end

dep 'wunder crontab configured' do
  requires 'wunder collect script installed',
           'wunder collect.crontab',
           'wunder backup script installed',
           'wunder backup.crontab'
end

dep 'wunder logrotate created' do
  def filename
    "/etc/logrotate.d/wunder"
  end

  def config
"""
/var/www/wunder.raygrasso.com/shared/cron_logs/*.log {
  weekly
  missingok
  rotate 5
}
"""
  end

  met? {
    filename.p.read == config
  }

  meet {
    filename.p.touch.write config
  }
end
