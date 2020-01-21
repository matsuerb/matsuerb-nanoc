# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

include Nanoc::Helpers::Tagging
include Nanoc::Helpers::Blogging
include Nanoc::Helpers::XMLSitemap
include Nanoc::Helpers::Rendering
include Nanoc::Helpers::Text
include Nanoc::Helpers::LinkTo

module Nanoc::Helpers::Tagging
  def link_for_tag(tag, base_url)
    %[<a href="#{h base_url}#{h tag}/" rel="tag">#{h tag}</a>]
  end
end

require 'icalendar'
# calendar.icsの作成時に75文字で改行されてGoogle Calendarにインポートできなくなるので追加
Icalendar::MAX_LINE_LENGTH = 200
