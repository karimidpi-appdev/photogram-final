# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  comments_count  :integer
#  email           :string
#  likes_count     :integer
#  password_digest :string
#  private         :boolean
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord

  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true

  validates(:username,
    {
      :presence => true, 
      :uniqueness => { :case_sensitive => false }
    }
  )

  has_secure_password


  # Direct Associations

  has_many(:likes, { :foreign_key => "fan_id", :dependent => :destroy })

  has_many(:comments, { :foreign_key => "author_id", :dependent => :destroy })

  has_many(:sent_follow_requests, { :class_name => "FollowRequest", :foreign_key => "sender_id", :dependent => :destroy })

  has_many(:received_follow_requests, { :class_name => "FollowRequest", :foreign_key => "recipient_id", :dependent => :destroy })

  has_many(:own_photos, { :class_name => "Photo", :foreign_key => "owner_id", :dependent => :destroy })


  # Indirect Associations 

  has_many(:following, { :through => :sent_follow_requests, :source => :recipient })

  has_many(:followers, { :through => :received_follow_requests, :source => :sender })

  has_many(:liked_photos, { :through => :likes, :source => :photo })

  has_many(:feed, { :through => :following, :source => :own_photos })

  has_many(:activity, { :through => :following, :source => :liked_photos })

  def comments
    return Comment.where({ :author_id => self.id })
  end

  def own_photos
    return Photo.where({ :owner_id => self.id })
  end

  def Likes
    return Like.where({ :fan_id => self.id })
  end

  def liked_photos
    array_of_photo_ids = self.likes.map_relation_to_array(:photo_id)

    return Photo.where({ :id => array_of_photo_ids })
  end

  def commented_photos
    array_of_photo_ids = self.comments.map_relation_to_array(:photo_id)

    return Photo.where({ :id => array_of_photo_ids }).distinct
  end

  def sent_follow_requests
    return FollowRequest.where({ :sender_id => self.id })
  end

  def received_follow_requests
    return FollowRequest.where({ :recipient_id => self.id })
  end

  def accepted_sent_follow_requests
    return self.sent_follow_requests.where({ :status => "accepted" })
  end

  def accepted_received_follow_requests
    return self.received_follow_requests.where({ :status => "accepted" })
  end

  def followers
    array_of_follower_ids = self.accepted_received_follow_requests.map_relation_to_array(:sender_id)

    return User.where({ :id => array_of_follower_ids })
  end

  def following
    array_of_leader_ids = self.accepted_sent_follow_requests.map_relation_to_array(:recipient_id)

    return User.where({ :id => array_of_leader_ids })
  end

  def feed
    array_of_leader_ids = self.accepted_sent_follow_requests.map_relation_to_array(:recipient_id)

    return Photo.where({ :owner_id => array_of_leader_ids })
  end

  def discover
    array_of_leader_ids = self.accepted_sent_follow_requests.map_relation_to_array(:recipient_id)

    all_leader_likes = Like.where({ :fan_id => array_of_leader_ids })

    array_of_discover_photo_ids = all_leader_likes.map_relation_to_array(:photo_id)

    return Photo.where({ :id => array_of_discover_photo_ids })
  end

end
