class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  after_create :get_gravatar
  
  before_destroy :delete_mutual_block!

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :profile_name, :avatar
  # attr_accessible :title, :body
  
  validates :first_name, presence: true

  validates :last_name, presence: true

  validates :profile_name, presence: true,
                           uniqueness: true,
                            format: {
                            with: /^[a-zA-Z0-9_-]+$/,
                            message: 'Must contain no spaces or foreign characters.'
                            }
  
  has_many :albums
  
  has_many :pictures
  
  has_many :statuses, dependent: :destroy

  has_many :user_friendships, dependent: :destroy

  has_many :friends, through: :user_friendships,
                     conditions: { user_friendships: {state: 'accepted' }},
                     dependent: :destroy
                     
  has_many :pending_user_friendships, class_name: 'UserFriendship',
                                      foreign_key: :user_id,
                                      conditions: { state: 'pending'},
                                         dependent: :destroy
                                      
                                      
  has_many :pending_friends, through: :pending_user_friendships, source: :friend, dependent: :destroy
  
  has_many :requested_user_friendships, class_name: 'UserFriendship',
                                      foreign_key: :user_id,
                                      conditions: { state: 'requested'}, dependent: :destroy
                                      
  has_many :requested_friends, through: :requested_user_friendships, source: :friend, dependent: :destroy
  
  has_many :blocked_user_friendships, class_name: 'UserFriendship',
                                      foreign_key: :user_id,
                                      conditions: { state: 'blocked'},
                                      dependent: :destroy
                                      
  has_many :blocked_friends, through: :blocked_user_friendships, source: :friend, dependent: :destroy
  
  has_many :accepted_user_friendships, class_name: 'UserFriendship',
                                      foreign_key: :user_id,
                                      conditions: { state: 'accepted'},    
                                      dependent: :destroy
                                      
  has_many :accepted_friends, through: :accepted_user_friendships, source: :friend, dependent: :destroy
  
  has_attached_file :avatar, styles: {
    large: "800x800#", medium: "300x200#", small: "260x180#", thumb: "80x80#"
  }
  
  def block!(user)
    transaction do
       friendship = UserFriendship.create!(user: self, friend: user, state: 'pending')
       friendship.update_attribute(:state, 'blocked')
    end
  end
  
  def self.get_gravatars
    all.each do |user|
      user.get_gravatar
      print "."
    end
  end
  
  def get_gravatar
    if !self.avatar?
       self.avatar = URI.parse(self.gravatar_url)
       self.save
    end
  end

  def full_name
  	first_name + " " + last_name
  end

  def to_param
    profile_name
  end

  def gravatar_url
    stripped_email = email.strip
    downcase_email = stripped_email.downcase
    hash = Digest::MD5.hexdigest(downcase_email)

    "http://gravatar.com/avatar/#{hash}"
  end
  
  def mutual_block
    UserFriendship.where({friend_id: self, state: 'blocked' }).first
  end
  
  def delete_mutual_block!
    mutual_block.delete if mutual_block
  end
  def has_blocked?(other_user)
    blocked_friends.include?(other_user)
  end
end
