dep 'bootstrap' do
  requires 'system', 'users', 'core software', 'server software', 'ruby development', 'passenger apache'
end

dep 'core software' do
  requires {
    on :linux, 'vim.bin', 'curl.bin', 'tree.bin', 'wget.bin', 'htop.bin', 'lsof.bin',
               'traceroute.bin', 'iotop.bin', 'jnettop.bin', 'tmux.bin', 'nmap.bin', 'pv.bin'
  }
end

dep 'server software' do
  requires {
    on :linux, 'postgres.managed'.with(version: '9.3'), 'mongodb', 'apache2.managed', 'npm'
  }
end

dep 'users' do
  requires 'user setup'.with(username: 'ray', key: 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAt/IBxUS+wEKjz1JVS15B5YfBqMGg1qpbCq+/P+F+W6Y0tV152Ky9BpvcfXYU2BmD/JokG6tzGilJVtG+4ihoF/fe9ZJuEQXFl1JlxVtplEZbrnpR4InQjHDIsxqOmBYaU7g/oOqZK4R72e8ThSqqJQ11Domd7EzM6XxURAhEuNe5H/vu2H2EbEcRE7quSeMD//xnFzRcrDCT4MeKDmaSjPuMOMdy5Q/2FGXNsC44Glgvt6s3TfE/JezKG4IuSKb4/qrH+reJ36P8/ItudLKzWt9445PtOxVtf6+1uhaFXyRpB3aTsLJp6NZKlrCsiltdJF5LG46TMCK6CBSQpMmbNQ== ray.grasso@gmail.com'),
           'user setup'.with(username: 'deploy', key: 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAt/IBxUS+wEKjz1JVS15B5YfBqMGg1qpbCq+/P+F+W6Y0tV152Ky9BpvcfXYU2BmD/JokG6tzGilJVtG+4ihoF/fe9ZJuEQXFl1JlxVtplEZbrnpR4InQjHDIsxqOmBYaU7g/oOqZK4R72e8ThSqqJQ11Domd7EzM6XxURAhEuNe5H/vu2H2EbEcRE7quSeMD//xnFzRcrDCT4MeKDmaSjPuMOMdy5Q/2FGXNsC44Glgvt6s3TfE/JezKG4IuSKb4/qrH+reJ36P8/ItudLKzWt9445PtOxVtf6+1uhaFXyRpB3aTsLJp6NZKlrCsiltdJF5LG46TMCK6CBSQpMmbNQ== ray.grasso@gmail.com')
end
