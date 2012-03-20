module ApplicationHelper
  def home_path
    if current_user
      community_path
    else
      "/"
    end
  end

  def md(content)
    MdPreview::Parser.parse(content)
  end

  def beta_testers
    yield if current_user.try(:beta_tester)
  end

  def gravatar(user, size=64)
    hash = Digest::MD5.hexdigest(user.email.downcase)

    image_tag "http://www.gravatar.com/avatar/#{hash}?s=#{size}&d=mm"
  end

  def error_messages_for(object)
    if object.errors.any?
      content_tag(:div, :id => "errorExplanation") do
        content_tag(:h2) { "Whoops, looks like something went wrong." } +
        content_tag(:p) { "Please review the form below and make the appropriate changes." } +
        content_tag(:ul) do
          object.errors.full_messages.map do |msg|
            content_tag(:li) { msg }
          end.join("\n").html_safe
        end
      end
    end
  end
end
