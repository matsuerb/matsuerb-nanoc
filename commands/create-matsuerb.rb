# -*- coding: utf-8 -*-
require 'date'
require 'fileutils'

usage 'create-matsuerb EVENT_DATE [options]'
aliases :cm
summary 'create news for a periodic Matsue.rb hackathon'
description <<EOS
This command create news for a periodic Matsue.rb hackathon in
content/news/<year>/<month1>/<day>/matsuerb_h<nengo><month2>.html.

  <year>, <month1> and <day> are Today or --date(-d) option.
  <nengo> and <month2> are EVENT_DATE option.

You modify generated file if you want.
EOS

flag(:h, :help, 'show help for this command') do |value, cmd|
  puts(cmd.help)
  exit(0)
end

option(:d, :date, 'specify created date [Default: Today]',
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

  created_date = opts[:date] ? Date.parse(opts[:date]) : Date.today

  nengo = event_date.year - 1988
  basename = "matsuerb_h#{nengo}#{event_date.strftime('%m')}.html"
  relative_path =
    'content/news/' + created_date.strftime('%Y/%m/%d/') + basename
  output_path = File.expand_path("../../#{relative_path}", __FILE__)
  FileUtils.mkdir_p(File.dirname(output_path))
  wday_s = {
    0 => '日',
    1 => '月',
    2 => '火',
    3 => '水',
    4 => '木',
    5 => '金',
    6 => '土',
    7 => '日',
  }
  File.open(output_path, "w") do |f|
    f.write(<<-EOS)
---
title: 「Matsue.rb定例会H#{nengo}.#{event_date.strftime('%m')}」開催のお知らせ
description: 平成#{nengo}年#{event_date.month}月#{event_date.day}日(#{wday_s[event_date.wday]})にMatsue.rb定例会H#{nengo}.#{event_date.strftime('%m')}を開催します。
created_at: #{created_date.strftime('%Y/%m/%d')}
kind: article
publish: true
tags: ["イベント"]
changefreq: never
priority: 0.5
---


　#{event_date.month}月#{event_date.day}日(#{wday_s[event_date.wday]})に<a href="<%= relative_path_to('/about_us/#matsuerb') %>">松江Ruby(Matsue.rb)定例会</a>を開催します。場所は松江オープンソースラボで、時間は09:30から17:30までです。
    EOS
  end
  puts("create: #{relative_path}")
end
