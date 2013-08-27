dep 'nginx.managed'

dep 'nginx running' do
  requires 'nginx.managed'
  met? { shell? 'service nginx status' }
  meet { sudo 'service nginx start', :log => true }
end

meta :nginx do
  def site_enabled?(site)
    sites_enabled.children.map{|file| file.basename}.include?(site.to_s)
  end

  def sites_enabled
    "/etc/nginx/sites-enabled".p
  end

  def sites_available
    "/etc/nginx/sites-available".p
  end

  template {
    requires 'nginx.managed'
  }
end

dep 'site enabled.nginx', :site do
  requires 'nginx running'
  met? { site_enabled? site }
  meet { sudo "ln -s '#{sites_available}/#{site}' '#{sites_enabled}/#{site}'" }
  after { sudo 'service nginx reload' }
end

dep 'site disabled.nginx', :site do
  met? { !site_enabled? site }
  meet { sudo "rm '#{sites_enabled}/#{site}'" }
  after { sudo 'service nginx reload' }
end

dep 'reverse proxy vhost.nginx', :site, :url, :port, :ssl, :hsts, :authentication, :htpasswd, :upstream_url, :upstream_authentication, :upstream_username, :upstream_password, :rewrites, :sub_filter, :default_server do
  site.default! url
  ssl.default! false
  hsts.default! false
  port.default!(ssl.current_value ? 443 : 80)
  default_server.default! false
  htpasswd.default! "htpasswd/#{url}.htpasswd"

  require 'base64'

  def destination
    "#{sites_available}/#{site}".p
  end

  def source
    "#{__FILE__.p.parent}/nginx/proxy.erb".p
  end

  def configuration
    require 'erb'
    @erb ||= ERB.new(source.read).result(binding)
  end

  def rewrite_config
    if rewrites.set?
      rewrites.current_value.map{|from, to|
        "rewrite #{from} #{to} break;"
      }.join("\n    ")
    else
      ''
    end
  end

  met? { destination.exists? and destination.read == configuration }
  meet { sudo "tee '#{destination}'", :input => configuration }
  after { shell! 'service nginx reload', :sudo => true }
end
