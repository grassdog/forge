dep 'ruby install' do
  requires {
    on :linux,
      'ruby-build',
      'chruby-global'#,
      # 'gemrc',
      # 'ruby 2.0.0',
      # 'default-ruby-version'.with(version_spec: '2.0.0'),
      # TODO Work out if these can be done in a single shot like this
      # 'common gems'
  }
end

dep 'ruby 2.0.0' do
  requires '2.0.0.chruby'
end

dep 'common gems' do
  requires 'bundler.gem',
           'passenger.gem'
end

dep 'bundler.gem' do
  gem_name 'bundler'
  ruby_version '2.0.0'
  requires '2.0.0.chruby'
  system_wide true
end

dep 'passenger.gem' do
  gem_name 'passenger'
  ruby_version '2.0.0'
  requires '2.0.0.chruby'
  system_wide true
end

dep 'pry-debugger.gem' do
  gem_name 'pry-debugger'
  ruby_version '2.0.0'
  requires '2.0.0.chruby'
end

