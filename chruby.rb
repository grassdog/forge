dep 'chruby' do
  version = '0.3.8'

  requires 'build-essential.managed'

  met? {
    '/usr/local/share/chruby/chruby.sh'.p.exists?
  }
  meet {

    install_path = "/tmp/chruby-#{version}"
    shell "rm -rf #{install_path}"
    shell "mkdir -p #{install_path}"

    cd install_path do |path|
      log_shell 'Downloading', "wget --no-check-certificate -O v#{version}.tar.gz https://github.com/postmodern/chruby/archive/v#{version}.tar.gz"
      log_shell 'Expanding archive', "tar zxvf v#{version}.tar.gz"
      cd "chruby-#{version}" do
        log_shell 'Install', 'make install', :sudo => true
      end
    end
  }
end

dep 'chruby-global' do
  requires 'chruby'

  temp = '/tmp/chruby.sh'
  profile = '/etc/profile.d/chruby.sh'
  config = <<EOF
[ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ] || return

source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh
chruby $(cat ~/.ruby-version 2> /dev/null || echo '2.1.1')
EOF

  met? {
    profile.p.exists? && profile.p.read == config
  }
  meet {
    temp.p.touch.write config
    sudo "mv #{temp} #{profile}"
  }
end

dep 'ruby', :version do
  requires 'ruby-build'

  def base_path
    '/opt/rubies'
  end

  def build_path
    base_path / version
  end

  met? {
    build_path.p.exists?
  }

  meet {
    shell "mkdir -p #{base_path}", :sudo => true
    log_shell 'Building via ruby-build', "/usr/local/bin/ruby-build #{version} #{build_path}", :sudo => true
  }
end

dep 'gem', :gem_name, :version, :ruby_version, :system_wide do
  system_wide.default!(false)
  version.default!(:unset)

  def version?
    version != :unset
  end

  def version_switch
    if version?
      "-v #{version}"
    else
      ""
    end
  end

  def version_test
    if version?
      /#{gem_name}\s+\([^(]*#{Regexp.escape version}/
    else
      /#{gem_name}/
    end
  end

  met? {
    log "Checking for gem #{gem_name} #{version_switch} under #{ruby_version}"
    shell("chruby-exec #{ruby_version} -- gem list #{gem_name}") =~ version_test
  }
  meet {
    log "Installing gem #{gem_name} #{version_switch} under #{ruby_version}"
    log_shell "gem install #{gem_name} #{version_switch}", "chruby-exec #{ruby_version} -- gem install #{gem_name} #{version_switch}"
  }
end

