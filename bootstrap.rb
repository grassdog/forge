dep 'bootstrap' do
  requires 'system', 'core software', 'server software', 'ruby development', 'passenger apache'
end

dep 'core software' do
  requires {
    on :linux, 'vim.bin', 'curl.bin', 'tree.bin', 'wget.bin', 'htop.bin', 'lsof.bin'
  }
end

dep 'server software' do
  requires {
    on :linux, 'postgres.managed'.with(version: '9.3'), 'mongodb', 'apache2.managed', 'npm'
  }
end

