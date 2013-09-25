class UserFriendshipDecorator < Draper::Decorator
  decorates :user_friendship
  delegate_all
  
  def friendship_state
    model.state.titleize
  end
  
  def sub_message
    case model.state
      when 'pending'
      "Friendship is pending"
      when 'accepted'
      "You are friends with #{model.friend.first_name}"
    end
  end
  
  def update_action_verbiage
    case model.state
    when 'pending'
      'Delete request'
    when 'requested'
      'Accept or Decline Friendship'
    when 'accepted'
      'Update Friendship'
    when 'blocked'
      'Unblock User'
    end
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
