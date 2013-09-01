require 'spec_helper'
require 'default'
require 'helper'
require 'tempfile'

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

describe 'members' do
  before do
    @tempfile = Tempfile.open("matsuerb_members")
  end

  it "matsuerb_members_list returns nothing#1" do
    @tempfile.write([].to_yaml)
    @tempfile.close
    matsuerb_members_list(@tempfile.path).should == ""
  end

  it "matsuerb_members_list returns nothing#2" do
    @tempfile.write([{name: "Foo Bar", public: false}].to_yaml)
    @tempfile.close
    matsuerb_members_list(@tempfile.path).should == ""
  end

  it "matsuerb_members_list returns one#1" do
    member = {
      name: "Foo Bar", profile: "foobar is nice guy",
      gravatar_hash: "0123456789", public: true,
    }
    @tempfile.write([member].to_yaml)
    @tempfile.close
    # TODO: HTML の構成が決まった後で要素にそった確認を行う。
    html = matsuerb_members_list(@tempfile.path)
    %i(name profile gravatar_hash).each do |s|
      html.should match(Regexp.new(member[s]))
    end
    %w(github twitter website).each do |s|
      html.should_not match(Regexp.new(s))
    end
  end

  it "matsuerb_members_list returns one#2" do
    member = {
      name: "Foo Bar", github: "foobar", twitter: "foobar",
      website: "http://www.example.org", profile: "foobar is nice guy",
      gravatar_hash: "0123456789", public: true,
    }
    @tempfile.write([member].to_yaml)
    @tempfile.close
    # TODO: HTML の構成が決まった後で要素にそった確認を行う。
    html = matsuerb_members_list(@tempfile.path)
    (member.keys - [:public]).each do |s|
      html.should match(Regexp.new(member[s]))
    end
  end
end
