# == Schema Information
#
# Table name: photos
#
#  id             :integer          not null, primary key
#  caption        :text
#  comments_count :integer
#  image          :string
#  image_url      :string
#  likes_count    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :integer
#
class Photo < ApplicationRecord
  mount_uploader :image, ImageUploader

  validates(:poster, { :presence => true })
  validates(:image, { :presence => true })

  # Direct Associations

  belongs_to(:owner, { :class_name => "User" })

  has_many(:likes, { :dependent => :destroy })

  has_many(:comments, { :dependent => :destroy })

  # Indirect Associations

  has_many(:fans, { :through => :likes, :source => :user })

  has_many(:followers, { :through => :owner, :source => :following })

  has_many(:fan_followers, { :through => :fans, :source => :following })

  def poster
    return User.where({ :id => self.owner_id }).at(0)
  end

  def comments
    return Comment.where({ :photo_id => self.id })
  end

  def likes
    return Like.where({ :photo_id => self.id })
  end

  def fans
    array_of_user_ids = self.likes.map_relation_to_array(:fan_id)

    return User.where({ :id => array_of_user_ids }).order({ :created_at => :desc })
  end

  def fan_list
    return self.fans.map_relation_to_array(:username).to_sentence
  end
end
