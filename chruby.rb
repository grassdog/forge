dep 'chruby' do
  version = '0.3.7'

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
chruby $(cat ~/.ruby-version 2> /dev/null || echo '2.0.0')
EOF

  met? {
    profile.p.exists?
  }
  meet {
    temp.p.touch.write config
    sudo "mv #{temp} #{profile}"
  }
end

meta :chruby do
  accepts_value_for :version, :basename
  accepts_value_for :patchlevel

  template {
    requires 'ruby-build'

    def base_path
      '/opt/rubies'
    end

    def version_spec
      "#{version}-#{patchlevel}"
    end

    def build_path
      base_path / version_spec
    end

    met? {
      build_path.p.exists?
    }

    meet {
      shell "mkdir -p #{base_path}", :sudo => true
      log_shell 'Building via ruby-build', "/usr/local/bin/ruby-build #{version_spec} #{build_path}", :sudo => true
    }
  }
end

dep '2.0.0.chruby' do
  patchlevel 'p247'
end

meta :gem do
  accepts_value_for :gem_name, :basename
  accepts_value_for :ruby_version, '2.0.0'
  accepts_value_for :system_wide, false
  accepts_value_for :version

  def version_switch
    if version
      "-v #{version}"
    else
      ""
    end
  end

  def version_test
    if version
      /#{gem_name}\s+\([^(]*#{Regexp.escape version}/
    else
      /#{gem_name}/
    end
  end

  template {
    met? {
      shell("chruby-exec #{ruby_version} -- gem list #{gem_name}") =~ version_test
    }
    meet {
      log_shell "gem install #{gem_name} #{version_switch}", "chruby-exec #{ruby_version} -- gem install #{gem_name} #{version_switch}"
    }
  }
end

dep 'default-ruby-version', :version_spec do
  version_spec.default!('2.0.0')

  met? { '~/.ruby-version'.p.grep version_spec }

  meet { '~/.ruby-version'.p.touch.write version_spec }
end

dep 'gemrc' do
  met? { '~/.gemrc'.p.exists? }
  meet {
    '~/.gemrc'.p.touch.write <<EOF
---
gem: --no-rdoc --no-ri
EOF
  }
end

