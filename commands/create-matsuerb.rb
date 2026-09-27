require 'date'
require 'fileutils'
require 'minigit'
require_relative '../lib/gengo'
require_relative '../lib/matsuerb_git'
require_relative '../lib/create_matsuerb_news'
require_relative '../lib/create_matsuerb_schedule'

# Implements the create-matsuerb command: creates news for a periodic
# Matsue.rb hackathon and adds a corresponding row to content/schedule.html.
class CreateMatsuerb
  def initialize(opts, args, cmd)
    @opts = opts
    @args = args
    @cmd = cmd
    @git = MiniGit::Capturing.new(File.expand_path('..', File.dirname(__FILE__)))
    @event_date = parse_event_date
    @created_date = opts[:date] ? Date.parse(opts[:date]) : Date.today
  end

  def run
    branch_name = "chore/add-teirei-#{@event_date.year}-#{'%02d' % @event_date.month}-news"
    MatsuerbGit.checkout_branch(@git, branch_name)

    news = CreateMatsuerbNews.new(@event_date, @created_date, @opts[:id])
    FileUtils.mkdir_p(File.dirname(news.output_path))
    File.write(news.output_path, news.content)
    puts("create: #{news.relative_path}")
    MatsuerbGit.commit(@git, news.relative_path, news.commit_message)

    schedule = CreateMatsuerbSchedule.new(@event_date, @opts[:id])
    schedule.insert_row!
    File.write(schedule.path, schedule.content)
    puts("update: #{schedule.relative_path}")
    MatsuerbGit.commit(@git, schedule.relative_path, schedule.commit_message)
  end

  private

  def parse_event_date
    Date.parse(@args.first)
  rescue StandardError
    puts('ERROR: you must specify EVENT_DATE')
    puts
    puts(@cmd.help)
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
