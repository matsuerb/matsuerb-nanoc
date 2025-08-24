require 'spec_helper'
require 'default'
require 'helper'
require 'tempfile'

describe 'fbe' do
  it "return html" do
    expect(fbe(99999)).to eq('<a href="https://www.facebook.com/events/99999/">Facebook</a>')
  end
end

describe 'copyright_year' do
  after do
    Timecop.return
  end

  [Time.mktime(2013, 1, 1, 0, 0, 0), Time.mktime(2014, 1, 1) - 1].each_with_index do |t, i|
    it "copyright_year returns 2013##{i + 1}" do
      Timecop.freeze(t)
      expect(copyright_year).to eq(OFFICIAL_SITE_START_YEAR.to_s)
    end
  end

  [Time.mktime(2014, 1, 1), Time.mktime(2015, 1, 1) - 1].each_with_index do |t, i|
    it "copyright_year returns 2013-2014##{i + 1}" do
      Timecop.freeze(t)
      expect(copyright_year).to eq("2013-2014")
    end
  end
end

describe 'link_to_osslab' do
  it "return html" do
    expect(link_to_osslab).to eq('<a href="https://www.city.matsue.lg.jp/soshikikarasagasu/shinsangyousouzouka/rcm/labo/14133.html">松江オープンソースラボ</a>')
  end
end

describe 'link_to_doorkeeper' do
  it "return html" do
    expect(link_to_doorkeeper('松江Ruby(Matsue.rb)定例会', 'matsue-rb', 99999)).to eq('<a href="http://matsue-rb.doorkeeper.jp/events/99999">松江Ruby(Matsue.rb)定例会</a>')
  end
end

describe 'link_to_connpass' do
  it "return html" do
    expect(link_to_connpass('松江Ruby(Matsue.rb)定例会', 'matsue-rb', 99999)).to eq('<a href="http://matsue-rb.connpass.com/event/99999">松江Ruby(Matsue.rb)定例会</a>')
  end
end

describe 'link_to_dojo' do
  it "return html" do
    expect(link_to_dojo(event_id: 99999)).to eq('<a href="http://smalruby.doorkeeper.jp/events/99999">コーダー道場 松江</a>')
  end
end

describe 'link_to_sproutrb' do
  context 'connpass' do
    it "return html" do
      expect(link_to_sproutrb(event_id: 99999)).to eq('<a href="http://sproutrb.connpass.com/event/99999">スプラウト.rb</a>')
    end
  end

  context 'doorkeeper' do
    it "return html" do
      expect(link_to_sproutrb(event_id: 99999, site_type: :doorkeeper)).to eq('<a href="http://sproutrb.doorkeeper.jp/events/99999">スプラウト.rb</a>')
    end
  end
end

describe 'link_to_terrsa' do
  it "return html" do
    expect(link_to_terrsa).to eq('<a href="http://www.sanbg.com/terrsa/">松江テルサ</a>')
  end
end

describe 'gravatar_image' do
  it "return html" do
    expect(gravatar_image('99999999999999999999999999999999')).to eq('<img src="http://www.gravatar.com/avatar/99999999999999999999999999999999" alt="" class="rounded-circle">')
  end
end

describe 'get_matsuerb_members' do
  let(:members_data1) do
    [
      {
        name: "Foo Bar",
        profile: "foobar is nice guy",
        gravatar_hash: "0123456789",
        public: true,
      }
    ]
  end
  let(:members_data2) do
    [
      {
        name: "Foo Bar",
        github: "foobar",
        twitter: "foobar",
        website: "http://www.example.org",
        profile: "foobar is nice guy",
        gravatar_hash: "0123456789",
        public: true,
      }
    ]
  end

  it 'return []' do
    [
      [].to_yaml,
      [{ name: "Foo Bar", public: false }].to_yaml
    ].each do |yaml|
      @tempfile = Tempfile.open("matsuerb_members")
      @tempfile.write(yaml)
      @tempfile.close
      expect(get_matsuerb_members(@tempfile.path)).to eq([])
    end
  end

  it 'return member json' do
    [
      members_data1,
      members_data2,
    ].each do |members_data|
      @tempfile = Tempfile.open("matsuerb_members")
      @tempfile.write(members_data.to_yaml)
      @tempfile.close
      members = get_matsuerb_members(@tempfile.path)
      expect(members.length).to eq(1)
      member = members.first
      member.keys.each do |member_attribute_name|
        expect(member[member_attribute_name]).to eq(members_data[0][member_attribute_name])
      end
    end
  end
end

describe 'create_links' do
  it 'return matrk6 html' do
    expected = [
      '<a target="_blank" href="https://www.flickr.com/groups/2875305@N22/pool/">1</a>',
      '<a target="_blank" href="https://www.flickr.com/groups/2860565@N21/pool/">2</a>',
      '<a target="_blank" href="https://www.flickr.com/groups/2819938@N24/pool/">3</a>',
      '<a target="_blank" href="https://www.flickr.com/groups/2813862@N25/pool/">4</a>',
      '<a target="_blank" href="https://www.flickr.com/groups/2863519@N23/pool/">5</a>',
      '<a target="_blank" href="https://www.flickr.com/groups/2886121@N22/pool/">6</a>',
      '<a target="_blank" href="https://www.flickr.com/groups/2823956@N23/pool/">7</a>',
      '<a target="_blank" href="https://www.flickr.com/groups/2849741@N23/pool/">8</a>',
      '<a target="_blank" href="https://www.flickr.com/groups/2886131@N22/pool/">9</a>',
    ].join(' ')
    expect(create_links(::PHOTO_PATHS[:matrk6])).to eq(expected)
  end

  it 'return matrk7 html' do
    expected = '<a target="_blank" href="https://www.flickr.com/groups/2901550@N22/pool/">写真一覧</a>'
    expect(create_links(::PHOTO_PATHS[:matrk7])).to eq(expected)
  end

  it 'return matrk8 html' do
    expected = '<a target="_blank" href="https://www.flickr.com/groups/4529348@N23/pool/">写真一覧</a>'
    expect(create_links(::PHOTO_PATHS[:matrk8])).to eq(expected)
  end
end
