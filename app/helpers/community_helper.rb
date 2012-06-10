module CommunityHelper
  def link_to_github(user)
    link_to user.github_nickname, "https://github.com/#{user.github_nickname}",
      :target => "_blank"
  end
end
