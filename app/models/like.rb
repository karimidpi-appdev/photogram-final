# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  fan_id     :integer
#  photo_id   :integer
#
class Like < ApplicationRecord
  
  validates(:photo_id, { :presence => true })
  
  validates(:photo_id, { :uniqueness => { :scope => ["fan_id"], :message => "already liked" } })
  
  validates(:fan_id, { :presence => true })

  # Direct Associations

  belongs_to(:user, { :foreign_key => "fan_id" })

  belongs_to(:photo, { :counter_cache => true })



  def fan
    return User.where({ :id => self.fan_id }).at(0)
  end

  def photo
    return Photo.where({ :id => self.photo_id }).at(0)
  end
  
end
