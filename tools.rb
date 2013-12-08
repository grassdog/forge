dep 's3cmd configured', :access_key, :secret_key do
  requires 's3cmd.managed'

  met? { '/home/vagrant/.s3cfg'.p.exists? }
  meet {
    render_erb 's3cmd/s3cfg.erb', :to => "~/.s3cfg", :perms => '600'
  }
end

