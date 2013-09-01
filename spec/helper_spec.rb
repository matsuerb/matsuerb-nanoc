require 'spec_helper'
require 'default'
require 'helper'

describe 'copyright' do
  after do
    Timecop.return
  end

  [Time.mktime(2013, 1, 1, 0, 0, 0), Time.mktime(2014, 1, 1) - 1].each_with_index do |t, i|
    it "copyright_year returns 2013##{i + 1}" do
      Timecop.freeze(t)
      copyright_year.should == OFFICIAL_SITE_START_YEAR.to_s
    end
  end

  [Time.mktime(2014, 1, 1), Time.mktime(2015, 1, 1) - 1].each_with_index do |t, i|
    it "copyright_year returns 2013-2014##{i + 1}" do
      Timecop.freeze(t)
      copyright_year.should == "2013-2014"
    end
  end
end
