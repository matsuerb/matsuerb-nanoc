# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

include Nanoc::Helpers::Tagging
include Nanoc::Helpers::Blogging
include Nanoc::Helpers::XMLSitemap
include Nanoc::Helpers::Rendering
include Nanoc::Helpers::Text

module Nanoc::Helpers::Tagging
  def link_for_tag(tag, base_url)
    %[<a href="#{h base_url}#{h tag}/" rel="tag">#{h tag}</a>]
  end
end
