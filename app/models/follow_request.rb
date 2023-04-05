# == Schema Information
#
# Table name: follow_requests
#
#  id           :integer          not null, primary key
#  status       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  recipient_id :integer
#  sender_id    :integer
#
class FollowRequest < ApplicationRecord
  validates(:recipient, { :presence => true })

  validates(:sender, { :presence => true })

  # belongs_to(:sender, { :class_name => "User", :counter_cache => :sent_follow_requests_count })

  # belongs_to(:recipient, { :class_name => "User", :counter_cache => :received_follow_requests_count })

  belongs_to :recipient, { :required => true, :class_name => "User", :foreign_key => "recipient_id" }

  belongs_to :sender, { :required => true, :class_name => "User", :foreign_key => "sender_id" }

  has_many :following_photos, :through => :recipient, :source => :photos

  def recipient
    return User.where({ :id => self.recipient_id }).at(0)
  end

  def sender
    return User.where({ :id => self.sender_id }).at(0)
  end
end
