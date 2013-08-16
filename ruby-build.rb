dep 'libcurl-dev.lib' do
  installs {
    via :yum, 'libcurl-devel'
  }
end

dep 'libreadline-dev.lib' do
  installs {
    via :yum, 'readline-devel'
  }
end

dep 'ruby-build' do
  requires [
    'libcurl-dev.lib',
    'libreadline-dev.lib',
    'benhoskings:zlib headers.managed',
    'benhoskings:yaml headers.managed',
    'benhoskings:openssl.lib'
  ]

  met? {
    in_path? 'ruby-build'
  }
  meet {
    install_path = '/tmp/ruby-build'
    shell "mkdir -p #{install_path}"
    git 'https://github.com/sstephenson/ruby-build.git', :to => install_path
    Dir.chdir(install_path) do
      sudo "./install.sh"
    end
  }
end

