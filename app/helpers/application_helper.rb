module ApplicationHelper
  def home_path
    if current_user
      community_path
    else
      "/"
    end
  end

  def md(content)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
      :autolink            => true,
      :space_after_headers => true,
      :no_intra_emphasis   => true)

    markdown.render(content).html_safe
  end

  def gravatar(user, size=64)
    hash = Digest::MD5.hexdigest(user.email.downcase)

    image_tag "http://www.gravatar.com/avatar/#{hash}?s=#{size}&d=mm"
  end
end
