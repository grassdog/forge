dep 'ruby', :version, :patchlevel do
  requires 'ruby-build'

  # version.default!('2.0.0')
  # patchlevel.default!('p247')

  version.default!('1.9.3')
  patchlevel.default!('p448')

  def full_version
    "#{version}-#{patchlevel}"
  end

  def path
    "~/.rubies/#{full_version}"
  end

  met? {
    path.p.exists?
  }

  meet {
    shell 'mkdir -p ~/.rubies'
    log_shell 'Building via ruby-build', "ruby-build #{full_version} #{path}"
  }
end

dep 'bundler.gem' do
  def should_sudo?; false end
end

dep 'pry-debugger.gem' do
  def should_sudo?; false end
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
