require 'date'
require 'fileutils'
require 'minigit'
require_relative '../lib/gengo'

# Implements the finish-matsuerb-schedule command: marks a periodic
# Matsue.rb hackathon as finished in content/schedule.html.
class FinishMatsuerbSchedule
  RELATIVE_PATH = 'content/schedule.html'.freeze

  def initialize(opts, args, cmd)
    @opts = opts
    @args = args
    @cmd = cmd
    @git = MiniGit::Capturing.new(File.expand_path('..', File.dirname(__FILE__)))
    @event_date = parse_event_date
  end

  def run
    gengo_letter, nendo = gengo_letter_and_nendo(@event_date)
    branch_name = "chore/closed-#{gengo_letter.downcase}#{nendo}#{month}"
    git_checkout_branch(branch_name)

    update_schedule(gengo_letter, nendo)
    puts("update: #{RELATIVE_PATH}")
    git_commit(RELATIVE_PATH, 'chore: スケジュールを更新')
  end

  private

  def month
    '%02d' % @event_date.month
  end

  def path
    File.expand_path("../../#{RELATIVE_PATH}", __FILE__)
  end

  def participants
    @opts[:participants] || 0
  end

  def parse_event_date
    Date.parse(@args.first)
  rescue StandardError
    puts('ERROR: you must specify EVENT_DATE')
    puts
    puts(@cmd.help)
    exit(1)
  end

  def update_schedule(gengo_letter, nendo)
    File.open(path, 'r+') do |f|
      content = f.read
      regexp = /(\|\s*Matsue.rb定例会#{gengo_letter}#{nendo}\.#{month}(?:\(#\d+\))?\s*\|)\s*参加受付中\s*\|/
      content.gsub!(regexp) { "#{Regexp.last_match(1)} 終了(#{participants}名参加) |" }
      f.rewind
      f.write(content)
      f.truncate(f.pos)
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
