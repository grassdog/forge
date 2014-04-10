dep 'passenger apache' do
  requires 'apt-transport-https.managed',
           'ca-certificates.managed',
           'passenger gpg key added',
           'passenger apt source added',
           'libapache2-mod-passenger.managed'
end

dep 'apt-transport-https.managed' do
   met? { `dpkg -s apt-transport-https 2>&1`.include?("\nStatus: install ok installed\n") }
end
dep 'ca-certificates.managed' do
   met? { `dpkg -s ca-certificates 2>&1`.include?("\nStatus: install ok installed\n") }
end

dep 'passenger gpg key added' do
  met? { `sudo apt-key list`[/AC40B2F7/] }
  meet { sudo "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7" }
end

dep 'passenger apt source added' do
  met? {
    "/etc/apt/sources.list".p.grep %r{^deb https://oss-binaries.phusionpassenger.com/apt/passenger saucy main$}
  }
  meet {
    sudo 'echo "deb https://oss-binaries.phusionpassenger.com/apt/passenger saucy main" >> /etc/apt/sources.list'
    sudo "apt-get update"
  }
end

dep 'libapache2-mod-passenger.managed' do
  met? { `dpkg -s libapache2-mod-passenger 2>&1`.include?("\nStatus: install ok installed\n") }

  after {
    sudo "a2enmod passenger"
  }
end

