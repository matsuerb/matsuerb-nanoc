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

  it "member_websites? returns true" do
    data = {github: "foo"}
    member_websites?(data).should eq(true)
    data[:twitter] = "foo"
    member_websites?(data).should eq(true)
    data[:website] = "http://example.com"
    member_websites?(data).should eq(true)
  end

  it "member_websites? returns false" do
    member_websites?({}).should eq(false)
    data = {name: "foo", profile: "foo", gravatar_hash: "42", public: true}
    member_websites?(data).should eq(false)
  end

  it "get_matsuerb_members returns nothing#1" do
    @tempfile.write([].to_yaml)
    @tempfile.close
    get_matsuerb_members(@tempfile.path).should == []
  end

  it "get_matsuerb_members returns nothing#2" do
    @tempfile.write([{name: "Foo Bar", public: false}].to_yaml)
    @tempfile.close
    get_matsuerb_members(@tempfile.path).should == []
  end

  it "get_matsuerb_members returns one#1" do
    data = [{
      name: "Foo Bar",
      profile: "foobar is nice guy",
      gravatar_hash: "0123456789",
      public: true,
    }]
    @tempfile.write(data.to_yaml)
    @tempfile.close
    members = get_matsuerb_members(@tempfile.path)
    members.length.should eq(1)
    member = members.first
    %i(name profile gravatar_hash public).each do |s|
      member[s].should eq(data[0][s])
    end
    %i(github twitter website).each do |s|
      member[s].should eq(nil)
    end
  end

  it "get_matsuerb_members returns one#2" do
    data = [{
      name: "Foo Bar",
      github: "foobar",
      twitter: "foobar",
      website: "http://www.example.org",
      profile: "foobar is nice guy",
      gravatar_hash: "0123456789",
      public: true,
    }]
    @tempfile.write(data.to_yaml)
    @tempfile.close
    members = get_matsuerb_members(@tempfile.path)
    members.length.should eq(1)
    member = members.first
    member.keys.each do |s|
      member[s].should eq(data[0][s])
    end
  end

  it "member_products? returns true" do
    data = {products: [{name: "foo", url: "http://example.com"}]}
    member_products?(data).should eq(true)
  end

  it "member_products? returns false" do
    member_products?({}).should eq(false)
    member_products?({products: [{name: "foo"}]}).should eq(false)
  end
end
