# frozen_string_literal: true

require 'date'
require_relative 'gengo'
require_relative 'matsuerb_git'
require_relative 'parse_event_date'
require_relative 'project_path'

# Implements the finish-matsuerb-schedule command: marks a periodic
# Matsue.rb hackathon as finished in content/schedule.html.
class FinishMatsuerbSchedule
  RELATIVE_PATH = 'content/schedule.html'

  def initialize(opts, args, cmd)
    @opts = opts
    @git = MiniGit::Capturing.new(PROJECT_ROOT)
    @event_date = parse_event_date(args, cmd)
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
    project_path(RELATIVE_PATH)
  end

  def participants
    @opts[:participants] || 0
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
