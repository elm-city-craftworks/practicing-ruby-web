module ApplicationHelper
  def home_path
    if current_user
      community_path
    else
      "/"
    end
  end
end
