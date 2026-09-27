# frozen_string_literal: true

require_relative 'gengo'

# Builds the news article for a periodic Matsue.rb hackathon and knows where
# to write it and what to commit it as.
class CreateMatsuerbNews
  def initialize(event_date, created_date, doorkeeper_id)
    @event_date = event_date
    @created_date = created_date
    @doorkeeper_id = doorkeeper_id
  end

  def relative_path
    "content/news/#{@created_date.strftime('%Y/%m/%d/')}#{basename}"
  end

  def output_path
    File.expand_path("../../../#{relative_path}", __FILE__)
  end

  def commit_message
    "chore: #{@event_date.month}/#{@event_date.day}(#{wday_ja(@event_date)})のお知らせを追加"
  end

  def content
    nengo_jp = nengo(@event_date, :jp)
    nengo_en = nengo(@event_date, :en)
    gengo_en = gengo(@event_date, :en)
    gengo_jp = gengo(@event_date, :jp)
    month2 = @event_date.strftime('%m')
    wday = wday_ja(@event_date)
    title = "Matsue.rb定例会#{gengo_en}#{nengo_en}.#{month2}"
    description = "#{gengo_jp}#{nengo_jp}年#{@event_date.month}月#{@event_date.day}日(#{wday})に#{title}を開催します。"

    <<~NEWS
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
    NEWS
  end

  private

  def basename
    "matsuerb_#{gengo(@event_date, :en).downcase}#{nengo(@event_date, :en)}#{@event_date.strftime('%m')}.html"
  end

  def link
    subject = '松江Ruby(Matsue.rb)定例会'
    if @doorkeeper_id
      "<%= link_to_doorkeeper('#{subject}', 'matsue-rb', #{@doorkeeper_id}) %>"
    else
      subject
    end
  end
end
