# -*- coding: utf-8 -*-
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
    html_source << '<li class="tagnum' + v.to_s + '"><a href="/tags/' + k + '/">' + k + '</a></li>'
  end
  html_source << '</ul>'
end

def tags_in_article
  tags = @item[:tags]
  html_source = '<ul">'
  tags.each do |k, v|
    html_source << '<li class="tagnum' + v.to_s + '"><a href="/tags/' + k + '/">' + k + '</a></li>'
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
    html_source << "<blockquote><small><a href='#{item.identifier}'>#{item[:title]}</a></small><p>#{strip_html(item.reps.first.compiled_content).slice(0,100)}...</p></blockquote>"
  end
  html_source
end

def article_list
  html_source = "<ul>"
  sorted_articles.each do |item|
    date = item[:updated_at]
    date ||= item[:created_at]
    html_source << "<li><a href='#{item.identifier}'>#{item[:title]}</a> - #{date}</li>"
  end
  html_source << "</ul>"
end

def fbe(id)
  return %Q'<a href="https://www.facebook.com/events/#{id}/">Facebook</a>'
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
  return %Q'<a href="http://matsue.rubyist.net/map/">#{lab}</a>'
end
