require 'date'
require 'fileutils'
require 'minigit'
require_relative '../lib/gengo'

# Implements the create-matsuerb command: creates news for a periodic
# Matsue.rb hackathon and adds a corresponding row to content/schedule.html.
class CreateMatsuerb
  WDAY_JA = %w[日 月 火 水 木 金 土].freeze

  def initialize(opts, args, cmd)
    @opts = opts
    @args = args
    @cmd = cmd
    @git = MiniGit::Capturing.new(File.expand_path('..', File.dirname(__FILE__)))
    @event_date = parse_event_date
    @created_date = opts[:date] ? Date.parse(opts[:date]) : Date.today
    @schedule_content = File.read(schedule_path)
  end

  def run
    basename = "matsuerb_#{gengo(@event_date, :en).downcase}#{nengo(@event_date, :en)}#{@event_date.strftime('%m')}.html"
    relative_path = 'content/news/' + @created_date.strftime('%Y/%m/%d/') + basename
    output_path = File.expand_path("../../#{relative_path}", __FILE__)
    FileUtils.mkdir_p(File.dirname(output_path))

    branch_name = "chore/add-teirei-#{@event_date.year}-#{'%02d' % @event_date.month}-news"
    git_checkout_branch(branch_name)

    File.write(output_path, matsuerb_news_content(news_link))
    puts("create: #{relative_path}")
    git_commit(relative_path, "chore: #{@event_date.month}/#{@event_date.day}(#{wday})のお知らせを追加")

    event_number = next_matsuerb_event_number
    insert_matsuerb_schedule_row(event_number)
    File.write(schedule_path, @schedule_content)
    puts("update: #{schedule_relative_path}")
    git_commit(schedule_relative_path, "chore: スケジュールに#{@event_date.month}/#{@event_date.day}(#{wday})の予定を追加")
  end

  private

  def wday
    WDAY_JA[@event_date.wday]
  end

  def schedule_relative_path
    'content/schedule.html'
  end

  def schedule_path
    File.expand_path("../../#{schedule_relative_path}", __FILE__)
  end

  def parse_event_date
    Date.parse(@args.first)
  rescue StandardError
    puts('ERROR: you must specify EVENT_DATE')
    puts
    puts(@cmd.help)
    exit(1)
  end

  def news_link
    subject = '松江Ruby(Matsue.rb)定例会'
    if @opts[:id]
      "<%= link_to_doorkeeper('#{subject}', 'matsue-rb', #{@opts[:id]}) %>"
    else
      subject
    end
  end

  def matsuerb_news_content(link)
    nengo_jp = nengo(@event_date, :jp)
    nengo_en = nengo(@event_date, :en)
    gengo_en = gengo(@event_date, :en)
    gengo_jp = gengo(@event_date, :jp)
    month2 = @event_date.strftime('%m')
    title = "Matsue.rb定例会#{gengo_en}#{nengo_en}.#{month2}"
    description = "#{gengo_jp}#{nengo_jp}年#{@event_date.month}月#{@event_date.day}日(#{wday})に#{title}を開催します。"

    <<~EOS
      ---
      title: 「#{title}」開催のお知らせ
      description: #{description}
      created_at: #{@created_date.strftime('%Y/%m/%d')}
      kind: article
      publish: true
      tags: ["イベント"]
      changefreq: never
      priority: 0.5
      calendar:
        year: #{@event_date.year}
        month: #{@event_date.month}
        day: #{@event_date.day}
        summary: #{title}
        description: #{description}
        start_time: "13:00"
        end_time: "17:00"
        location: 島根県松江市朝日町478番地18　松江テルサ別館2階
      ---


      <p>　#{@event_date.month}月#{@event_date.day}日(#{wday})に#{link}を開催します。場所は<%= link_to_osslab %>で、時間は13:00から17:00までです。</p>
    EOS
  end

  def next_matsuerb_event_number
    @schedule_content.scan(/\(#(\d+)\)/).map { |m| m[0].to_i }.max + 1
  end

  def matsuerb_schedule_row(event_number)
    gengo_letter, nendo = gengo_letter_and_nendo(@event_date)
    doorkeeper_id = @opts[:id]
    link =
      if doorkeeper_id
        "<%= link_to_doorkeeper('Doorkeeper', 'matsue-rb', #{doorkeeper_id}) %>"
      else
        ''
      end
    "| Matsue.rb定例会#{gengo_letter}#{nendo}.#{@event_date.strftime('%m')}(##{event_number})| " \
      "参加受付中 | #{@event_date.strftime('%Y/%m/%d')} 13:00-17:00 | <%= link_to_osslab %>   | 不要   |無料| #{link} |\n"
  end

  def matsuerb_schedule_new_section(section_header, row)
    <<~SEC
      #{section_header}

      <div markdown="1" class="table_schedule pb-4" >

      |イベント名                  |状態          |日時                   |会場                    |事前登録|料金|リンク                      |
      |----------------------------|--------------|-----------------------|------------------------|--------|----|----------------------------|
      #{row}
      </div>

    SEC
  end

  # Inserts a new "参加受付中" row for the current event into @schedule_content.
  # The row is added to the top of the matching 令和/平成 year section (events are
  # listed in reverse chronological order); if that year has no section yet, a
  # new one is created just before the previous year's section.
  def insert_matsuerb_schedule_row(event_number)
    _, nendo = gengo_letter_and_nendo(@event_date)
    row = matsuerb_schedule_row(event_number)
    section_header = "## #{gengo(@event_date, :jp)}#{nendo.to_i}年"

    if @schedule_content.include?("#{section_header}\n")
      section_re = /(#{Regexp.escape(section_header)}\n\n<div markdown="1" class="table_schedule pb-4" >\n\n\|.*\|\n\|[-|]+\|\n)/
      raise "table header for #{section_header} not found in content/schedule.html" unless @schedule_content =~ section_re

      @schedule_content = @schedule_content.sub(section_re) { $1 + row }
    else
      raise 'no existing year section found in content/schedule.html' unless @schedule_content =~ /^## (?:令和|平成)/

      new_section = matsuerb_schedule_new_section(section_header, row)
      @schedule_content = @schedule_content.sub(/^## (?=令和|平成)/) { new_section + '## ' }
    end
  end

  def git_checkout_branch(branch_name)
    @git.checkout(b: branch_name)
  rescue MiniGit::GitError
    exit(1)
  end

  def git_commit(relative_path, message)
    @git.add(relative_path)
    @git.commit({m: message}, relative_path)
  rescue MiniGit::GitError
    exit(1)
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
  CreateMatsuerb.new(opts, args, cmd).run
end
