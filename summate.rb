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

