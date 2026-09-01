require 'date'
require 'fileutils'
require 'minigit'

def gengo(type)
  case type
  when :jp
    '令和'
  when :en
    'R'
  else
    raise
  end
end

def nengo(year, type)
  n = '%02d' % (year - 2018)
  case type
  when :jp
    n == '01' ? '元' : n
  when :en
    n
  else
    raise
  end
end

def next_matsuerb_event_number(schedule_content)
  schedule_content.scan(/\(#(\d+)\)/).map { |m| m[0].to_i }.max + 1
end

# Inserts a new "参加受付中" row for the given event into content/schedule.html.
# The row is added to the top of the matching 令和/平成 year section (events are
# listed in reverse chronological order); if that year has no section yet, a
# new one is created just before the previous year's section.
def insert_matsuerb_schedule_row(schedule_content, event_date, event_number, doorkeeper_id)
  reiwa_year = event_date.year - 2018
  nengo_en = '%02d' % reiwa_year
  month2 = event_date.strftime('%m')
  link =
    if doorkeeper_id
      "<%= link_to_doorkeeper('Doorkeeper', 'matsue-rb', #{doorkeeper_id}) %>"
    else
      ''
    end
  row = "| Matsue.rb定例会R#{nengo_en}.#{month2}(##{event_number})| 参加受付中 | #{event_date.strftime('%Y/%m/%d')} 13:00-17:00 | <%= link_to_osslab %>   | 不要   |無料| #{link} |\n"

  section_header = "## 令和#{reiwa_year}年"

  if schedule_content.include?("#{section_header}\n")
    section_re = /(#{Regexp.escape(section_header)}\n\n<div markdown="1" class="table_schedule pb-4" >\n\n\|.*\|\n\|[-|]+\|\n)/
    raise "table header for #{section_header} not found in content/schedule.html" unless schedule_content =~ section_re

    schedule_content.sub(section_re) { $1 + row }
  else
    raise 'no existing year section found in content/schedule.html' unless schedule_content =~ /^## (?:令和|平成)/

    new_section = <<~SEC
      #{section_header}

      <div markdown="1" class="table_schedule pb-4" >

      |イベント名                  |状態          |日時                   |会場                    |事前登録|料金|リンク                      |
      |----------------------------|--------------|-----------------------|------------------------|--------|----|----------------------------|
      #{row}
      </div>

    SEC
    schedule_content.sub(/^## (?=令和|平成)/) { new_section + '## ' }
  end
end

usage 'create-matsuerb EVENT_DATE [options]'
aliases :cm
summary 'create news for a periodic Matsue.rb hackathon'
description <<EOS
This command create news for a periodic Matsue.rb hackathon in
content/news/<year>/<month1>/<day>/matsuerb_h<nengo><month2>.html,
and adds a corresponding row to content/schedule.html.

  <year>, <month1> and <day> are Today or --date(-d) option.
  <nengo> and <month2> are EVENT_DATE option.

You modify generated file if you want.
EOS

flag(:h, :help, 'show help for this command') do |value, cmd|
  puts(cmd.help)
  exit(0)
end

option(:i, :id, 'specify doorkeeper ID', argument: :optional, default: nil)
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

  nengo_jp = nengo(event_date.year, :jp)
  nengo_en = nengo(event_date.year, :en)
  basename = "matsuerb_#{gengo(:en).downcase}#{nengo_en}#{event_date.strftime('%m')}.html"
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

  subject = '松江Ruby(Matsue.rb)定例会'
  if opts[:id]
    link = "<%= link_to_doorkeeper('#{subject}', 'matsue-rb', #{opts[:id]}) %>"
  else
    link = subject
  end
  File.open(output_path, "w") do |f|
    f.write(<<-EOS)
---
title: 「Matsue.rb定例会#{gengo(:en)}#{nengo_en}.#{event_date.strftime('%m')}」開催のお知らせ
description: #{gengo(:jp)}#{nengo_jp}年#{event_date.month}月#{event_date.day}日(#{wday_s[event_date.wday]})にMatsue.rb定例会#{gengo(:en)}#{nengo_en}.#{event_date.strftime('%m')}を開催します。
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
  summary: Matsue.rb定例会#{gengo(:en)}#{nengo_en}.#{event_date.strftime('%m')}
  description: #{gengo(:jp)}#{nengo_jp}年#{event_date.month}月#{event_date.day}日(#{wday_s[event_date.wday]})にMatsue.rb定例会#{gengo(:en)}#{nengo_en}.#{event_date.strftime('%m')}を開催します。
  start_time: "13:00"
  end_time: "17:00"
  location: 島根県松江市朝日町478番地18　松江テルサ別館2階
---


<p>　#{event_date.month}月#{event_date.day}日(#{wday_s[event_date.wday]})に#{link}を開催します。場所は<%= link_to_osslab %>で、時間は13:00から17:00までです。</p>
    EOS
  end
  puts("create: #{relative_path}")
  begin
    git.add(relative_path)
    git.commit({m: "#{event_date.month}/#{event_date.day}(#{wday_s[event_date.wday]})のお知らせを追加"}, relative_path)
  rescue MiniGit::GitError
    exit(1)
  end

  schedule_relative_path = 'content/schedule.html'
  schedule_path = File.expand_path("../../#{schedule_relative_path}", __FILE__)
  schedule_content = File.read(schedule_path)
  event_number = next_matsuerb_event_number(schedule_content)
  updated_schedule_content =
    insert_matsuerb_schedule_row(schedule_content, event_date, event_number, opts[:id])
  File.write(schedule_path, updated_schedule_content)
  puts("update: #{schedule_relative_path}")
  begin
    git.add(schedule_relative_path)
    git.commit({m: "スケジュールに#{event_date.month}/#{event_date.day}(#{wday_s[event_date.wday]})の予定を追加"}, schedule_relative_path)
  rescue MiniGit::GitError
    exit(1)
  end
end
