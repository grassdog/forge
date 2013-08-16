dep 'vim' do
  # https://github.com/mcgain/babushka-deps/blob/master/vim.rb
  # https://github.com/rweng/babushka-deps/blob/master/vim.rb

  # 'ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2'
  requires ['ncurses.managed']

  met? do
    return false unless in_path? 'vim'

    version = shell("vim --version")
    version.include?('Vi IMproved 7.3') and
    version.include?('Compiled by babushka') and
    version.include?('+ruby') and
    version.include?('+python')
  end

  meet do
    Babushka::Resource.extract 'ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2' do |path|

      log_shell 'configuring', './configure --prefix=/usr/local/ --enable-rubyinterp --enable-gui=no --disable-gpm --enable-pythoninterp --enable-multibyte -with-features=huge --with-compiledby=babushka'

      log_shell 'building', 'make'
      sudo 'make install'
    end
  end
end
