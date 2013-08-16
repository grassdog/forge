dep 'dotfiles' do
  met? {
    '~/.dotfiles'.p.exists?
  }
  meet {
    git 'https://github.com/compactcode/dot-files.git', :to => '~/.dot-files' do
      # TODO Finish downloading
      # log_block('Running install.sh') do
      #   shell './install.sh'
      #   shell 'chsh -s $(which zsh)'
      # end
    end
  }
end

# dep 'system preferences' do
#   requires {
#     on :osx, 'osx terminal preferences'
#   }
# end

# dep 'osx terminal preferences' do
#   met? {
#     shell('defaults read com.apple.Terminal').include?('name = "Solarized Dark"')
#   }
#   meet {
#     # Hack alert.
#     shell('open preferences/terminal/Solarized\ Dark.terminal')
#     shell('open preferences/terminal/Solarized\ Light.terminal')
#     # Need to wait for preferences to be written.
#     shell('sleep 5')
#   }
# end
