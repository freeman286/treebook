class UserController < ApplicationController
  
  def block
    @user = User.find(params[:user_id])
    if !current_user.block!(@user)
      flash[:alert] = "That user could not be blocked"
    end
    redirect_to user_friendships_path
  end
  
end  
