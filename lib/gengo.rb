# frozen_string_literal: true

require 'date'

GENGO_JP_BY_LETTER = {
  'M' => '明治',
  'T' => '大正',
  'S' => '昭和',
  'H' => '平成',
  'R' => '令和'
}.freeze

# Returns [gengo_letter, nendo] for the given date, e.g. ['R', '08'] for
# 2026-10-10. Uses Date#jisx0301 so this stays correct across era changes.
def gengo_letter_and_nendo(date)
  date.jisx0301.match(/\A([A-Z])(\d+)\./).captures
end

def gengo(date, type)
  letter, = gengo_letter_and_nendo(date)
  case type
  when :jp
    GENGO_JP_BY_LETTER.fetch(letter) { raise "unknown gengo letter: #{letter}" }
  when :en
    letter
  else
    raise
  end
end

def nengo(date, type)
  _, n = gengo_letter_and_nendo(date)
  case type
  when :jp
    n == '01' ? '元' : n
  when :en
    n
  else
    raise
  end
end
