# -*- coding: utf-8 -*-

require 'yaml'

def get_tags(items)
  tag_num_hash = Hash.new(0)
  items.each do |item|
    if item[:tags]
      item[:tags].each do |tag|
        tag_num_hash[tag] += 1
      end
    end
  end
  return tag_num_hash
end

def tags_page
  tags = get_tags(@items)
  html_source = '<ul">'
  tags.each do |k, v|
    html_source << '<li class="tagnum' + v.to_s + '">' + link_to(k, "/tags/#{k}/") + '</li>'
  end
  html_source << '</ul>'
end

def tags_in_article
  tags = @item[:tags]
  html_source = '<ul">'
  tags.each do |k, v|
    html_source << '<li class="tagnum' + v.to_s + '">' + link_to(k, "/tags/#{k}/") + '</li>'
  end
  html_source << '</ul>'
end

def tag_page
  tags = get_tags(@items)
  tags.each do |k, v|
    page_stats = {:title => "tag: #{k}", :tag_page_title => "#{k}"}
    option = {:binary => false}
    @items << Nanoc::Item.new("<%= render('_tag') %>", page_stats, "/tags/#{k}/", option)
  end
end

def tag_page_item_list(tag)

#  html_source = '<dl">'
  html_source = ""
  items_with_tag(tag).each do |item|
    html_source << "<blockquote><small>#{link_to(item[:title], item.identifier)}</small><p>#{strip_html(item.reps.first.compiled_content).slice(0,100)}...</p></blockquote>"
  end
  html_source
end

def article_list
  html_source = "<ul>"
  sorted_articles.each do |item|
    date = item[:updated_at]
    date ||= item[:created_at]
    html_source << "<li>#{link_to(item[:title], item.identifier)} - #{date}</li>"
  end
  html_source << "</ul>"
end

def fbe(id)
  return link_to("Facebook", "https://www.facebook.com/events/#{id}/")
end

OFFICIAL_SITE_START_YEAR = 2013

def copyright_year
  start_year = OFFICIAL_SITE_START_YEAR
  this_year = Time.now.year
  if start_year == this_year
    start_year.to_s
  else
    [start_year, this_year].join("-")
  end
end

def link_to_osslab(lab = "松江オープンソースラボ")
  return link_to(lab, "/map/")
end

# http://ja.gravatar.com/site/implement/images/ruby/
def gravatar_image(hash)
  return %Q!<img src="http://www.gravatar.com/avatar/#{hash}">!
end

def matsuerb_members_list(path = 'resources/members.yml', public_only = true)
  members = YAML.load(File.read(path))
  members.reject! {|m| !m[:public]} if public_only
  return members.collect { |member|
    li_lists = {github: "https://github.com/", twitter: "https://twitter.com/", website: ""}.collect { |sym, url_base|
      url = member[sym]
      (!url.nil? && url != "") ? "<li>#{link_to(sym.to_s, url_base + member[sym])}</li>" : ""
    }.join
    %Q!<div class="wrp test clearfix"><div class="img">#{gravatar_image(member[:gravatar_hash])}</div><div class="text"><h3>#{member[:name]}</h3><p>#{member[:profile]}</p><ul class="links">#{li_lists}</ul></div></div>\n!
  }.join
end
