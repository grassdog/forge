# These deps need to be run in root
dep 'stage1' do
  requires 'postgres-apt-repo'
end


dep 'ruby development' do
  requires {
    on :linux,
      'ruby-build',
      'chruby-global',
      'gemrc',
      'ruby 1.9.3',
      'ruby 2.0.0',
      'default-ruby-version'.with(version_spec: '2.0.0')
  }
end

dep 'ruby 1.9.3' do
  requires '1.9.3.chruby',
           'bundler.1.9.3.gem',
           'pry-debugger.1.9.3.gem'
end

dep 'ruby 2.0.0' do
  requires '2.0.0.chruby',
           'bundler.2.0.0.gem',
           'pry-debugger.2.0.0.gem'
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
