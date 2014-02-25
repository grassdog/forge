dep 'ruby environment' do
  requires {
    on :linux,
      'ruby-build',
      'chruby-global',
      'gemrc',
      '2.1.1.ruby_base',
      'default-ruby-version'.with(version_spec: '2.1.1')
  }
end

dep 'default-ruby-version', :version do
  version.default!('2.1.1')

  met? { '~/.ruby-version'.p.grep version }

  meet { '~/.ruby-version'.p.touch.write version }
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

meta 'ruby_base' do
  accepts_value_for :version, :basename

  template {
    requires 'ruby'.with(version: version)
    requires 'gem'.with(gem_name: 'bundler', ruby_version: version)
    requires 'gem'.with(gem_name: 'passenger', ruby_version: version)
  }
end

dep '2.0.0-p247.ruby_base'
dep '2.1.1.ruby_base'

