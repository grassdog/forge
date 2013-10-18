dep 'existing postgres db', :username, :db_name do
  requires 'postgres access'.with(:username => username)
  met? {
    !sudo("psql -l", as: username) {|shell|
      shell.stdout.split("\n").grep(/^\s*#{db_name}\s+\|/)
    }.empty?
  }
  meet {
    sudo "createdb -O '#{username}' '#{db_name}'", as: username
  }
end

dep 'existing data', :username, :db_name do
  requires 'existing postgres db'.with(username, db_name)
  met? {
    shell("psql #{db_name} -c '\\d'").scan(/\((\d+) rows?\)/).flatten.first.tap {|rows|
      if rows && rows.to_i > 0
        log "There are already #{rows} tables."
      else
        unmeetable! <<-MSG
The '#{db_name}' database is empty. Load a database dump with:
$ cat #{db_name}.psql | ssh #{username}@#{shell('hostname -f')} 'psql #{db_name}'
        MSG
      end
    }
  }
end

dep 'postgres installed' do
  requires 'postgres.managed'.with(version: '9.3'),
           'postgres password encrypted config'
end

dep 'postgres access', :username, :flags do
  requires 'postgres.managed'
  requires 'user exists'.with(:username => username)
  username.default(shell('whoami'))
  flags.default!('-SdR')
  met? { !sudo("echo '\\du' | #{which 'psql'}", :as => 'postgres').split("\n").grep(/^\W*\b#{username}\b/).empty? }
  meet { sudo "createuser #{flags} #{username}", :as => 'postgres' }
end

dep 'postgres gpg key added' do
  met? { `sudo apt-key list`[/ACCC4CF8/] }
  meet { sudo "wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -" }
end

dep 'postgres apt source added' do
  met? {
    "/etc/apt/sources.list".p.grep %r{^deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main$}
  }
  meet {
    sudo 'echo "deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main" >> /etc/apt/sources.list'
    sudo "apt-get update"
  }
end

dep 'postgres.managed', :version do
  version.default('9.3')
  # Assume the installed version if there is one
  version.default!(shell('psql --version').val_for('psql (PostgreSQL)')[/^\d\.\d/]) if which('psql')

  requires 'set.locale', 'postgres gpg key added', 'postgres apt source added'

  installs {
    via :apt, ["postgresql-#{owner.version}", "libpq-dev"]
    via :brew, "postgresql"
  }
  provides "psql ~> #{version}.0"
end

dep 'postgres password encrypted config' do
  met? {
    "/etc/postgresql/9.3/main/postgresql.conf".p.grep /^password_encryption = on/
  }
  meet {
    shell "sed -i'' -e 's/^#password_encryption = on/password_encryption = on/' /etc/postgresql/9.3/main/postgresql.conf"
  }
  after {
    shell "/etc/init.d/postgresql restart"
  }
end

