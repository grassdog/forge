dep 'ruby-build' do
  requires_when_unmet [
    'curl.lib',
    'build-essential.managed',
    'readline headers.managed',
    'zlib headers.managed',
    'yaml headers.managed',
    'openssl.lib',
    'libssl headers.managed'
  ]

  met? {
    in_path? 'ruby-build'
  }
  meet {
    install_path = '/tmp/ruby-build'
    shell "mkdir -p #{install_path}"
    git 'https://github.com/sstephenson/ruby-build.git', :to => install_path
    Dir.chdir(install_path) do
      sudo './install.sh'
    end
  }
end

