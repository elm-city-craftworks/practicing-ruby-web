class CommentsController < ApplicationController
  before_filter :find_comment,     :only => [:show, :update, :destroy]
  before_filter :commentator_only, :only => [:update, :destroy]

  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user

    if @comment.save
      flash[:notice] = "Comment posted!"
      redirect_to article_path(@comment.commentable)
    else
      flash[:error] = "Please enter some text to create a comment!"
      @article  = @comment.commentable
      @comments = @article.comments
      render "articles/show"
    end
  end

  def show
    render :text => @comment.body
  end

  def update
    @comment.update_attribute(:body, params[:value])

    respond_to do |format|
      format.text
    end
  end

  def destroy
    @comment.destroy

    respond_to do |format|
      format.js
    end
  end

  private

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def commentator_only
    raise "Access Denied" if @comment.user != current_user
  end
end
