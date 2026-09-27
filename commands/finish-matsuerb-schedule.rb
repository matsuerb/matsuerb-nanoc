require_relative '../command_lib/finish_matsuerb_schedule'

usage 'finish-matsuerb-schedule EVENT_DATE [options]'
aliases :fms
summary 'finish schedule for a periodic Matsue.rb hackathon'
description <<EOS
This command finish schedule for a periodic Matsue.rb hackathon in
content/schedule.html.

You modify updated file if you want.
EOS

flag(:h, :help, 'show help for this command') do |value, cmd|
  puts(cmd.help)
  exit(0)
end

option(:p, :participants, 'specify number of participant [Default: 0]',
       :argument => :optional)

run do |opts, args, cmd|
  FinishMatsuerbSchedule.new(opts, args, cmd).run
end
