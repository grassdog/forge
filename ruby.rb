dep 'ruby development' do
  requires {
    on :linux,
      'ruby-build',
      'chruby-global',
      'gemrc',
      'ruby 2.0.0',
      'default-ruby-version'.with(version_spec: '2.0.0')
  }
end

dep 'ruby 2.0.0' do
  requires '2.0.0.chruby',
    # TODO Need to log out before running these gem installs so chruby can kick in
           'bundler.2.0.0.gem',
           'passenger.2.0.0.gem'
end

dep 'bundler.2.0.0.gem' do
  gem_name 'bundler'
  ruby_version '2.0.0'
  requires '2.0.0.chruby'
  system_wide true
end

dep 'pry-debugger.2.0.0.gem' do
  gem_name 'pry-debugger'
  ruby_version '2.0.0'
  requires '2.0.0.chruby'
end

