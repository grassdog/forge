dep 'chruby' do
  version = '0.3.6'

  # TODO Install in system instead of user space

  met? {
    '/usr/local/share/chruby/chruby.sh'.p.exists?
  }
  meet {

    install_path = "/tmp/chruby-#{version}"
    shell("rm -rf #{install_path}")
    shell "mkdir -p #{install_path}"

    cd install_path do |path|
      log_shell 'Downloading', "wget -O v#{version}.tar.gz https://github.com/postmodern/chruby/archive/v#{version}.tar.gz"
      log_shell 'Expanding archive', "tar zxvf v#{version}.tar.gz"
      cd "chruby-#{version}" do
        log_shell 'Install', 'sudo make install'
      end
    end
  }
end

dep 'chruby-profile' do
  requires 'chruby'

  profile = '~/.bashrc'

  met? {
    profile.p.grep %r{source /usr/local/share/chruby/chruby\.sh}
  }
  meet {
    log_shell 'Adding chruby to profile', "echo 'source /usr/local/share/chruby/chruby.sh' >> #{ENV['HOME']}/.bashrc"
    log_shell 'Adding chruby auto to profile', "echo 'source /usr/local/share/chruby/auto.sh' >> #{ENV['HOME']}/.bashrc"
    profile.p.append <<EOF
# Chruby
if [[ -e /usr/local/share/chruby/chruby.sh ]]; then
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh
  chruby $(cat ~/.ruby-version)
fi
EOF
    log_shell 'Sourcing profile', "source #{profile}"
  }
end

dep 'default-ruby-version', :version do
  version.default!('1.9.3')

  met? { '~/.ruby-version'.p.exists? }

  meet { '~/.ruby-version'.p.touch.write version }
end
