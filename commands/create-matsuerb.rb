# -*- coding: utf-8 -*-
require 'date'
require 'fileutils'
require 'minigit'

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

flag(:j, :rubyjr, 'generate Ruby.Jr, too.')
option(:s, :sproutrb, 'generate Sprout.rb, too. [Default: No Event Page]',
       argument: :optional, default: nil)
option(:c, :coderdojo, 'generate CoderDojo, too.  [Default: No Event Page]',
       argument: :optional, default: nil)
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

  git = MiniGit::Capturing.new(File.expand_path('..', File.dirname(__FILE__)))
  branch_name =
    "add-teirei-#{event_date.year}-#{"%02d" % event_date.month}-news"
  begin
    git.checkout(b: branch_name)
  rescue MiniGit::GitError
    exit(1)
  end

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
calendar:
  year: #{event_date.year}
  month: #{event_date.month}
  day: #{event_date.day}
  summary: Matsue.rb定例会H#{nengo}.#{event_date.strftime('%m')}
  description: 平成#{nengo}年#{event_date.month}月#{event_date.day}日(#{wday_s[event_date.wday]})にMatsue.rb定例会H#{nengo}.#{event_date.strftime('%m')}を開催します。
  start_time: "9:30"
  end_time: "17:00"
  location: 島根県松江市朝日町478番地18　松江テルサ別館2階
---


<p>　#{event_date.month}月#{event_date.day}日(#{wday_s[event_date.wday]})に<%= link_to("松江Ruby(Matsue.rb)定例会", "/about_us/#matsuerb") %>を開催します。場所は<%= link_to_osslab %>で、時間は09:30から17:00までです。</p>
    EOS

    if [opts[:rubyjr], opts[:sproutrb], opts[:coderdojo]].any?
      table = ""
      if opts[:rubyjr]
        table << <<-EOS
| <%= link_to_rubyjr %> |Matsue.rbグループのメンバーが講師やアシスタントを努める中高生プログラミング教室 | 18:00-19:30(定例会の後)       |
        EOS
      end
      if opts[:sproutrb]
        eid = opts[:sproutrb].kind_of?(String) ? opts[:sproutrb] : "nil"
        table << <<-EOS
| <%= link_to_sproutrb(event_id: #{eid}) %> |Ruby on Rails勉強会。現在はRuby on Rails チュートリアルの読書会を実施           | 13:00-17:00(定例会と同時開催) |
        EOS
      end
      if opts[:coderdojo]
        eid = opts[:coderdojo].kind_of?(String) ? opts[:coderdojo] : "nil"
        table << <<-EOS
| <%= link_to_dojo(event_id: #{eid}) %>     |子ども(主に小学校3年生から中学校2年生まで)のためのプログラミング教室            | 13:30-16:30(定例会と同時開催) |
        EOS
      end
      f.write(<<-EOS)
<p>　また、当日は以下のイベントもオープンソースラボで開催される予定です。詳細はリンク先をご覧ください。

<div markdown="1" class="table_wrapper" style="width: 95%">

| イベント名                               |説明                                                                            |時間                           |
|:-----------------------------------------|:-------------------------------------------------------------------------------|:------------------------------|
#{table}
</div>

</p>
      EOS
    end
  end
  puts("create: #{relative_path}")
  begin
    git.add(relative_path)
    git.commit({m: "#{event_date.month}/#{event_date.day}(#{wday_s[event_date.wday]})のお知らせを追加。"}, relative_path)
  rescue MiniGit::GitError
    exit(1)
  end
end
