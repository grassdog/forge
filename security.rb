dep 'ufw ssh and http only' do
  requires 'ufw.managed'

  setup {
    unmeetable! "This dep has to be run as root." unless shell('whoami') == 'root'
  }

  met? {
    status = shell("ufw status")
    status.match /Status: active/ and
    status.match /80\/tcp\s+ALLOW/ and
    status.match /22\/tcp\s+ALLOW/
  }

  meet {
    shell "ufw default deny" and
    shell "ufw allow 80/tcp" and
    shell "ufw allow 22/tcp" and
    shell "ufw --force enable"
  }
end

dep 'ufw.managed'

dep 'fail2ban apache enabled' do
  requires 'fail2ban.managed'

  def content
    "/etc/fail2ban/jail.conf".p.read
  end

  met? {
    content.match %r{\[apache\]\n\nenabled\s+=\s+true}m
  }
  meet {
    "/etc/fail2ban/jail.conf".p.write content.gsub(%r{\[apache\]\n\nenabled\s+=\s+false}m, "[apache]\n\nenabled = true")
  }
  after {
    shell "/etc/init.d/fail2ban restart"
  }
end

dep 'fail2ban.managed' do
  met? { `dpkg -s fail2ban 2>&1`.include?("\nStatus: install ok installed\n") }
end

