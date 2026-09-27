# frozen_string_literal: true

require 'date'
require_relative 'gengo'
require_relative 'matsuerb_git'

# Implements the finish-matsuerb-schedule command: marks a periodic
# Matsue.rb hackathon as finished in content/schedule.html.
class FinishMatsuerbSchedule
  RELATIVE_PATH = 'content/schedule.html'

  def initialize(opts, args, cmd)
    @opts = opts
    @args = args
    @cmd = cmd
    @git = MiniGit::Capturing.new(File.expand_path('..', __dir__))
    @event_date = parse_event_date
  end

  def run
    gengo_letter, nendo = gengo_letter_and_nendo(@event_date)
    branch_name = "chore/closed-#{gengo_letter.downcase}#{nendo}#{month}"
    MatsuerbGit.checkout_branch(@git, branch_name)

    update_schedule(gengo_letter, nendo)
    puts("update: #{RELATIVE_PATH}")
    MatsuerbGit.commit(@git, RELATIVE_PATH, 'chore: スケジュールを更新')
  end

  private

  def month
    format('%02d', @event_date.month)
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
end
