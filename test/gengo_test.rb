# frozen_string_literal: true

require 'test_helper'
require 'gengo'

describe 'gengo_letter_and_nendo' do
  it 'returns the era letter and zero-padded nendo' do
    _(gengo_letter_and_nendo(Date.new(2026, 10, 10))).must_equal(%w[R 08])
  end

  it 'is correct right before an era change' do
    _(gengo_letter_and_nendo(Date.new(2019, 4, 30))).must_equal(%w[H 31])
  end

  it 'is correct right after an era change' do
    _(gengo_letter_and_nendo(Date.new(2019, 5, 1))).must_equal(%w[R 01])
  end
end

describe 'gengo' do
  it 'returns the Japanese era name for :jp' do
    _(gengo(Date.new(2026, 10, 10), :jp)).must_equal('令和')
  end

  it 'returns the Japanese era name for a past era' do
    _(gengo(Date.new(2019, 4, 30), :jp)).must_equal('平成')
  end

  it 'returns the era letter for :en' do
    _(gengo(Date.new(2026, 10, 10), :en)).must_equal('R')
  end

  it 'raises for an unknown type' do
    _(proc { gengo(Date.new(2026, 10, 10), :fr) }).must_raise(RuntimeError)
  end
end

describe 'nengo' do
  it 'returns "元" for the first year of an era in :jp' do
    _(nengo(Date.new(2019, 5, 1), :jp)).must_equal('元')
  end

  it 'returns the zero-padded number for other years in :jp' do
    _(nengo(Date.new(2026, 10, 10), :jp)).must_equal('08')
  end

  it 'returns the zero-padded number for :en, including for the first year' do
    _(nengo(Date.new(2019, 5, 1), :en)).must_equal('01')
    _(nengo(Date.new(2026, 10, 10), :en)).must_equal('08')
  end

  it 'raises for an unknown type' do
    _(proc { nengo(Date.new(2026, 10, 10), :fr) }).must_raise(RuntimeError)
  end
end

describe 'wday_ja' do
  it 'returns the kanji weekday' do
    _(wday_ja(Date.new(2026, 10, 10))).must_equal('土')
    _(wday_ja(Date.new(2026, 10, 12))).must_equal('月')
  end
end
