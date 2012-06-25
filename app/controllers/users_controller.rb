class UsersController < ApplicationController
  before_filter :find_user, :except => :show

  def show
    @user = User.find_by_github_nickname(params[:id])

    raise ActionController::RoutingError.new('Not Found') unless @user

    @user = UserDecorator.decorate(@user)
  end

  def edit

  end

  def update
    if @user.update_attributes(cleaned_params)
      flash[:notice] = "Settings sucessfully updated!"
      redirect_to edit_user_path(@user)
    else
      render :action => :edit
    end
  end

  private

  def find_user
    @user = current_user
  end

  def cleaned_params
    approved_params = %w{notify_conversations notify_mentions notify_comment_made
      beta_tester}

    params[:user].select {|k,_| approved_params.include? k }
  end
end
