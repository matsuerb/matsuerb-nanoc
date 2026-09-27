# frozen_string_literal: true

require 'test_helper'
require 'create_matsuerb_news'

describe CreateMatsuerbNews do
  before do
    @event_date = Date.new(2026, 12, 12)
    @created_date = Date.new(2026, 9, 26)
  end

  describe 'without a doorkeeper id' do
    before do
      @news = CreateMatsuerbNews.new(@event_date, @created_date, nil)
    end

    it 'builds the relative path from the created date and event date' do
      _(@news.relative_path).must_equal('content/news/2026/09/26/matsuerb_r0812.html')
    end

    it 'builds a commit message with the event date and weekday' do
      _(@news.commit_message).must_equal('chore: 12/12(土)のお知らせを追加')
    end

    it 'uses the plain subject (no doorkeeper link) in the article body' do
      _(@news.content).must_include('松江Ruby(Matsue.rb)定例会を開催します')
      _(@news.content).wont_include('link_to_doorkeeper')
    end

    it 'includes the era-formatted title and description' do
      _(@news.content).must_include('title: 「Matsue.rb定例会R08.12」開催のお知らせ')
      _(@news.content).must_include('令和08年12月12日(土)')
    end
  end

  describe 'with a doorkeeper id' do
    before do
      @news = CreateMatsuerbNews.new(@event_date, @created_date, 12345)
    end

    it 'includes a doorkeeper link in the article body' do
      _(@news.content).must_include("link_to_doorkeeper('松江Ruby(Matsue.rb)定例会', 'matsue-rb', 12345)")
    end
  end
end
