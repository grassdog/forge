dep 'summate' do
  requires 'libqtwebkit-dev.managed',
           'xvfb',
           'summate db',
           'summate.raygrasso.com.apache_rails',
           'summate fetch.crontab',
           'summate backup.crontab'
end

dep 'summate db' do
  requires 'existing postgres db'.with(username: 'summatedb', db_name: 'summate_production')
end

dep 'summate.raygrasso.com.apache_rails'

dep 'summate.raygrasso.com.vhost' do
  webroot "/var/www/summate.raygrasso.com"
  hostname "summate.raygrasso.com"
end

dep 'libqtwebkit-dev.managed' do
  met? { `dpkg -s libqtwebkit-dev 2>&1`.include?("\nStatus: install ok installed\n") }
end

# Fetch at specific hours in the day
dep 'summate fetch.crontab' do
  schedule "0 7,13,17,21 * * *"
  command "/bin/bash -l -c 'cd /var/www/summate.raygrasso.com/current && xvfb-run ./bin/rake RAILS_ENV=production fetch:netbank >> /var/www/summate.raygrasso.com/shared/logs/fetch_cron.log'"
end

dep 'summate backup.crontab' do
  schedule "5 8 * * 6"
  command "/bin/bash -l -c 'cd /var/www/summate.raygrasso.com/current && ./bin/rake RAILS_ENV=production db:backup"
end

# Need xvfb so that headless webkit can run with an xserver on Ubuntu
dep 'xvfb' do
  requires 'xvfb.managed', 'display-profile'
end

dep 'xvfb.managed' do
  met? { `dpkg -s xvfb 2>&1`.include?("\nStatus: install ok installed\n") }
end

dep 'display-profile' do
  profile = '/etc/profile.d/display.sh'
  config = "\nexport DISPLAY=localhost:1.0\n"

  met? {
    profile.p.exists? && profile.p.read == config
  }
  meet {
    profile.p.touch.write.config
  }
end


dep 'summate logrotate created' do
  def filename
    "/etc/logrotate.d/summate"
  end

  def config
"""
/var/www/summate.raygrasso.com/shared/logs/fetch_cron.log {
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
