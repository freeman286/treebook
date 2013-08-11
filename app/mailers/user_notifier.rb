class UserNotifier < ActionMailer::Base
  default from: "from@example.com"
  def friend_requetsed(user_friendship_id)
  	user_friendship = User_friendship.find(user_friendship_id)

  	@user = user_friendship.user
  	@friend = user_friendship.friend

  	mail to: @friend.email,
  		 subject: "#{@user.first_name} wants to be friends on treebook"
  end	
end
