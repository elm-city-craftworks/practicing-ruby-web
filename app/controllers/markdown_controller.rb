class MarkdownController < ApplicationController

  def parse
    @text = params[:text]
  end

end
