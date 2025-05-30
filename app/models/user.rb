# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  comments_count         :integer
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  likes_count            :integer
#  private                :boolean
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         has_many  :photos, foreign_key: "owner_id", dependent: :destroy
         has_many  :comments, foreign_key: "author_id", dependent: :destroy
         has_many :likes, foreign_key: "fan_id"
         has_many :liked_photos, through: :likes, source: :photo
         has_many :follow_sent, class_name: "FollowRequest", foreign_key: "sender_id", dependent: :destroy
         has_many :follow_received, class_name: "FollowRequest", foreign_key: "recipient_id", dependent: :destroy
         has_many :followers, through: :follow_received, source: :sender
         has_many :following, through: :follow_sent, source: :recipient
         
  # app/models/user.rb (Add this helper method)
  def find_like_for(photo)
    likes.find_by(photo_id: photo.id)
  end


  # Finds any existing follow request (pending or accepted) sent by this user to another_user
  def follow_request_to(other_user)
    follow_sent.find_by(recipient_id: other_user.id)
  end

  def following?(other_user)
    follow_sent.exists?(recipient_id: other_user.id, status: 'accepted')
  end


  def pending_follow_request_to?(other_user)
    request = follow_request_to(other_user)
    request && request.status == 'pending'
  end


  def accepted_following
    following.merge(FollowRequest.where(status: "accepted"))
  end

end
