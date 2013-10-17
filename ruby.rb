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


