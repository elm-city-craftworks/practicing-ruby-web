class UserDecorator < ApplicationDecorator
  decorates :user

  def member_since
    h.l(user.created_at.to_date, :format => :long)
  end

  def icon(size=32)
    image_path = h.image_path("avatar.png")

    unless user.contact_email.blank?
      hash       = Digest::MD5.hexdigest(user.contact_email.downcase)
      default    = CGI.escape("http://#{h.request.host_with_port}#{image_path}")
      image_path = "http://www.gravatar.com/avatar/#{hash}?s=#{size}&d=#{default}"
    end

    # Manually set height / width so layouts don't collapse while gravatars are
    # loading
    #
    h.image_tag(image_path, :alt => user.name,
      :style => "width: #{size}px; height: #{size}px;", :class => "user-icon")
  end

  def link_to_github
    h.link_to user.github_nickname, github_url
  end

  def github_url
    "https://github.com/#{user.github_nickname}"
  end
end