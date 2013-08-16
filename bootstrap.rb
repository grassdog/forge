
dep 'ruby development' do
  requires {
    on :linux,
      'ruby-build',
      'chruby-global',
      '1.9.3.chruby',
      'gemrc',
      'default-ruby-version',
      'bundler.gem'.with(:version => '1.9.3'),
      'pry-debugger.gem'.with(:version => '1.9.3'),
      '2.0.0.chruby',
      'bundler.gem'.with(:version => '2.0.0'),
      'pry-debugger.gem'.with(:version => '2.0.0')
  }
end

dep 'core software' do
  requires {
    on :linux, 'vim.bin', 'curl.bin', 'tree.bin', 'wget.managed', 'htop.bin', 'lsof.bin'
  }
end


# TODO Add ag
# requires 'compactcode:ack.managed'
#requires 'benhoskings:ncurses.managed'

# User
# requires 'compactcode:dot files'
# requires 'compactcode:system preferences'

# # Common
# requires 'compactcode:autojump.managed'

# # Application
# requires 'compactcode:Dropbox.app'
# requires 'compactcode:Firefox.app'
# requires 'compactcode:Google Chrome.app'

#https://github.com/compactcode/babushka-deps/blob/macbook/user.rb
