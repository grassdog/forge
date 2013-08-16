dep 'dev-box' do
  requires 'benhoskings:tree.bin'
  requires 'compactcode:ack.managed'
  requires 'benhoskings:ncurses.managed'
  requires 'ruby-build'
  requires 'chruby'
  requires 'chruby-profile'
  requires 'default-ruby-version'
  requires 'ruby'
  requires 'bundler.gem'
  requires 'pry-debugger.gem'

  # requires 'custom:ruby'.with(version: '1.9.3', patchlevel: 'p448')

  # User
  # requires 'compactcode:dot files'
  # requires 'compactcode:system preferences'

  # # Common
  # requires 'compactcode:ack.managed'
  # requires 'compactcode:autojump.managed'
  # requires 'compactcode:wget.managed'

  # # Application
  # requires 'compactcode:Dropbox.app'
  # requires 'compactcode:Firefox.app'
  # requires 'compactcode:Google Chrome.app'

  #https://github.com/compactcode/babushka-deps/blob/macbook/user.rb
end
