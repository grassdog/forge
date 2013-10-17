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
           'bundler.2.0.0.gem',
           'pry-debugger.2.0.0.gem',
           'passenger.2.0.0.gem'
end

dep 'bundler.2.0.0.gem' do
  gem_name 'bundler'
  ruby_version '2.0.0'
  requires '2.0.0.chruby'
end

dep 'pry-debugger.2.0.0.gem' do
  gem_name 'pry-debugger'
  ruby_version '2.0.0'
  requires '2.0.0.chruby'
end

