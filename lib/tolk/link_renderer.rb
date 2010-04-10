module Tolk
  class LinkRenderer < WillPaginate::LinkRenderer
    def to_html
      links = @options[:page_links] ? windowed_links : []
      # previous/next buttons
      links.unshift page_link_or_span(@collection.previous_page, 'disabled prev_page', @options[:previous_label])
      links.push    page_link_or_span(@collection.next_page,     'disabled next_page', @options[:next_label])
      
      html = links.join(@options[:separator])
      @options[:container] ? @template.content_tag(:div, html.html_safe, html_attributes) : html.html_safe
    end

    protected

    def page_link(page, text, attributes = {})
      @template.link_to text.html_safe, url_for(page), attributes
    end

    def page_span(page, text, attributes = {})
      @template.content_tag :span, text.html_safe, attributes
    end
  end
end
