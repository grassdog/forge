dep 'summate' do
  requires 'libqtwebkit-dev.managed',
           'summate db',
           'summate.raygrasso.com.apache_rails'

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

# TODO Add cron job for fetch
# xvfb-run ./bin/rake RAILS_ENV=production fetch:netbank

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
