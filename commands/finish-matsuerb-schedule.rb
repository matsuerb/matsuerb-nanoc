require 'date'
require 'fileutils'
require 'minigit'

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
  begin
    event_date = Date.parse(args.first)
  rescue
    puts('ERROR: you must specify EVENT_DATE')
    puts
    puts(cmd.help)
    exit(1)
  end

  relative_path = 'content/schedule.html'
  output_path = File.expand_path("../../#{relative_path}", __FILE__)

  git = MiniGit::Capturing.new(File.expand_path('..', File.dirname(__FILE__)))
  nendo = event_date.year - 1988
  month = "%02d" % event_date.month
  branch_name = "closed_h#{nendo}#{month}"
  begin
    git.checkout(b: branch_name)
  rescue MiniGit::GitError
    exit(1)
  end

  n = opts[:participants] || 0
  File.open(output_path, "r+") do |f|
    s = f.read
    regexp = /(\|\s*Matsue.rb定例会H#{nendo}\.#{month}\s*\|)\s*参加受付中\s*\|/
    s.gsub!(regexp) { $1 + " 終了(#{n}名参加) |" }
    f.rewind
    f.write(s)
    f.truncate(f.pos)
  end
  puts("update: #{relative_path}")
  begin
    git.add(relative_path)
    git.commit({m: "スケジュールを更新。"}, relative_path)
  rescue MiniGit::GitError
    exit(1)
  end
end
