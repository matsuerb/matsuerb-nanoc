# frozen_string_literal: true

require 'test_helper'
require 'create_matsuerb_schedule'

# CreateMatsuerbSchedule#initialize reads the real content/schedule.html
# (read-only; #insert_row! only mutates the in-memory @content, never
# writes to disk), so these assertions are written relative to whatever
# is already there instead of hard-coding an exact event number or row.
describe CreateMatsuerbSchedule do
  it 'exposes the file path and commit message for the given event date' do
    schedule = CreateMatsuerbSchedule.new(Date.new(2026, 12, 12), nil)
    _(schedule.relative_path).must_equal('content/schedule.html')
    _(schedule.commit_message).must_equal('chore: スケジュールに12/12(土)の予定を追加')
  end

  it 'inserts a new row with an event number one higher than the current max' do
    schedule = CreateMatsuerbSchedule.new(Date.new(2026, 12, 12), nil)
    max_before = schedule.content.scan(/\(#(\d+)\)/).map { |m| m[0].to_i }.max

    schedule.insert_row!

    max_after = schedule.content.scan(/\(#(\d+)\)/).map { |m| m[0].to_i }.max
    _(max_after).must_equal(max_before + 1)
    _(schedule.content).must_include("Matsue.rb定例会R08.12(##{max_after})")
    _(schedule.content).must_include('2026/12/12 13:00-17:00')
  end

  it 'puts the new row before the previously-first row of the same year section' do
    schedule = CreateMatsuerbSchedule.new(Date.new(2026, 12, 12), nil)
    first_row_before = schedule.content.lines.find { |l| l.start_with?('| ') }

    schedule.insert_row!

    first_row_after = schedule.content.lines.find { |l| l.start_with?('| ') }
    _(first_row_after).must_include('2026/12/12')
    _(first_row_after).wont_equal(first_row_before)
  end

  it 'includes a doorkeeper link when a doorkeeper id is given' do
    schedule = CreateMatsuerbSchedule.new(Date.new(2026, 12, 12), 12345)
    schedule.insert_row!
    _(schedule.content).must_include("link_to_doorkeeper('Doorkeeper', 'matsue-rb', 12345)")
  end

  it 'leaves the link column blank when no doorkeeper id is given' do
    schedule = CreateMatsuerbSchedule.new(Date.new(2026, 12, 12), nil)
    schedule.insert_row!
    _(schedule.content).must_include('|無料|  |')
  end
end
