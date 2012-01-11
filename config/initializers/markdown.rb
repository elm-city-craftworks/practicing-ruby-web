module MdPreview
  module CustomParser
    extend self

    def parse(content)
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
        :autolink            => true,
        :space_after_headers => true,
        :no_intra_emphasis   => true,
        :fenced_code_blocks  => true)

      syntax_highlighter(markdown.render(content)).html_safe
    end

    def syntax_highlighter(html)
      doc = Nokogiri::HTML(html)

      doc.search("//code[@class]").each do |code|
        code.parent.replace Albino.colorize(code.text.rstrip, code[:class])
      end

      doc.xpath("//body").children.to_s
    end
  end
end