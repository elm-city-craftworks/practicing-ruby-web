class HTMLwithAlbino < Redcarpet::Render::HTML
  def block_code(code, language)
    Albino.colorize(code, language)
  end
end

Markdown = Redcarpet::Markdown.new(HTMLwithAlbino,
  :autolink            => true,
  :space_after_headers => true,
  :no_intra_emphasis   => true,
  :fenced_code_blocks  => true)

