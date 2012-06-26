module MdMentions
  class Render < MdEmoji::Render
    def paragraph(text)
      mentioned_text = text.gsub(/@([a-z\d-]+)(\.[a-z]{3})?/i) do |mention|
        github = $1
        user   = User.where("LOWER(github_nickname) = ?", github.downcase).exists?

        if user && $2.blank?
          %{<a href="/users/#{github}" class="mention">@#{github}</a>}
        else
          mention
        end
      end

      super mentioned_text
    end
  end
end