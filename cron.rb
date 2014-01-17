
meta :crontab do
  accepts_value_for :schedule
  accepts_value_for :command

  template {
    def existing_crontab
      shell("crontab -l") || ""
    end

    def cron_line(schedule, command)
      "#{schedule} #{command}"
    end

    met? {
      existing_crontab.include? cron_line(schedule, command)
    }
    meet {
      new_crontab = existing_crontab
      new_crontab << "\n"
      new_crontab << "#{cron_line(schedule, command)}\n"
      # puts "GRASS"
      # puts new_crontab
      shell("crontab -", :input => new_crontab)
    }
  }
end
