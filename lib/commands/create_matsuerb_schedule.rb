# frozen_string_literal: true

require_relative 'gengo'

# Inserts a new "参加受付中" row for a periodic Matsue.rb hackathon into
# content/schedule.html, and knows what to commit that change as.
# The row is added to the top of the matching 令和/平成 year section (events
# are listed in reverse chronological order); if that year has no section
# yet, a new one is created just before the previous year's section.
class CreateMatsuerbSchedule
  RELATIVE_PATH = 'content/schedule.html'

  attr_reader :content

  def initialize(event_date, doorkeeper_id)
    @event_date = event_date
    @doorkeeper_id = doorkeeper_id
    @content = File.read(path)
  end

  def relative_path
    RELATIVE_PATH
  end

  def path
    File.expand_path("../../../#{RELATIVE_PATH}", __FILE__)
  end

  def commit_message
    "chore: スケジュールに#{@event_date.month}/#{@event_date.day}(#{wday_ja(@event_date)})の予定を追加"
  end

  def insert_row!
    row = schedule_row(next_event_number)
    section_header = "## #{gengo(@event_date, :jp)}#{nendo.to_i}年"

    @content =
      if @content.include?("#{section_header}\n")
        insert_into_existing_section(section_header, row)
      else
        insert_into_new_section(section_header, row)
      end
  end

  private

  def nendo
    _, n = gengo_letter_and_nendo(@event_date)
    n
  end

  def next_event_number
    @content.scan(/\(#(\d+)\)/).map { |m| m[0].to_i }.max + 1
  end

  def schedule_row(event_number)
    gengo_letter, n = gengo_letter_and_nendo(@event_date)
    link =
      if @doorkeeper_id
        "<%= link_to_doorkeeper('Doorkeeper', 'matsue-rb', #{@doorkeeper_id}) %>"
      else
        ''
      end
    "| Matsue.rb定例会#{gengo_letter}#{n}.#{@event_date.strftime('%m')}(##{event_number})| " \
      "参加受付中 | #{@event_date.strftime('%Y/%m/%d')} 13:00-17:00 | <%= link_to_osslab %>   | 不要   |無料| #{link} |\n"
  end

  def insert_into_existing_section(section_header, row)
    section_re = /(#{Regexp.escape(section_header)}\n\n<div markdown="1" class="table_schedule pb-4" >\n\n\|.*\|\n\|[-|]+\|\n)/
    raise "table header for #{section_header} not found in content/schedule.html" unless @content =~ section_re

    @content.sub(section_re) { ::Regexp.last_match(1) + row }
  end

  def insert_into_new_section(section_header, row)
    raise 'no existing year section found in content/schedule.html' unless @content =~ /^## (?:令和|平成)/

    new_section = <<~SEC
      #{section_header}

      <div markdown="1" class="table_schedule pb-4" >

      |イベント名                  |状態          |日時                   |会場                    |事前登録|料金|リンク                      |
      |----------------------------|--------------|-----------------------|------------------------|--------|----|----------------------------|
      #{row}
      </div>

    SEC
    @content.sub(/^## (?=令和|平成)/) { "#{new_section}## " }
  end
end
