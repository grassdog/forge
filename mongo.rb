dep 'mongodb' do
  requires \
    '10gen gpg key added',
    '10gen apt source added',
    'mongodb-10gen'
end

dep '10gen gpg key added' do
  met? { `sudo apt-key list`[/7F0CEB10/] }
  meet { sudo "apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10" }
end

dep '10gen apt source added' do
  met? {
    "/etc/apt/sources.list".p.grep %r{^deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen$}
  }
  meet {
    sudo 'echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" >> /etc/apt/sources.list'
    sudo "apt-get update"
  }
end

dep 'mongodb-10gen' do
  met? { `dpkg -s mongodb-10gen 2>&1`.include?("\nStatus: install ok installed\n") }
  meet { sudo "apt-get -y install mongodb-10gen" }
end
