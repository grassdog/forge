dep 'summate db' do
  requires 'existing postgres db'.with(username: 'summatedb', db_name: 'summate_production')
end

dep 'summate.raygrasso.com.apache_rails'

dep 'summate.raygrasso.com.vhost' do
  webroot "/var/www/summate.raygrasso.com"
  hostname "summate.raygrasso.com"
end

# TODO Add webkit packages
# TODO Add cron job for fetch

