class CommentsController < ApplicationController
  before_filter :authenticate
  before_filter :authenticate_user
  before_filter :find_comment,     :only => [:show, :update, :destroy]
  before_filter :commentator_only, :only => [:update, :destroy]

  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user

    if @comment.save
      flash[:notice] = "Comment posted!"
      redirect_to article_path(@comment.commentable, :anchor => "comments")
    else
      flash[:error] = "Please enter some text to create a comment!"
      redirect_to article_path(@comment.commentable)
    end
  end

  def show
    render :text => @comment.body
  end

  def update
    @comment.update_attributes(:body => params[:value])
    expire_fragment("comment_body_#{@comment.id}")

    decorate

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

  def parse
    @comment = Comment.new(:body => params[:text])

    decorate

    render :text => @comment.content
  end

  private

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def decorate
    @comment = @comment.decorate
  end

  def commentator_only
    raise "Access Denied" unless @comment.editable_by? current_user
  end
end
