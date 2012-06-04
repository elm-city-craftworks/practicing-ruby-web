module MdMentions
  class Render < MdEmoji::Render
    def paragraph(text)
      mentioned_text = text.gsub(/@([a-z\d-]+)/i) do |mention|
        %{<a href="/users/#{mention[1..-1]}" class="mention">#{mention}</a>}
      end

      super mentioned_text
    end
  end
end