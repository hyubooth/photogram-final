# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :integer
#  photo_id   :integer
#
class Comment < ApplicationRecord
  validates(:author_id, presence: true)
  belongs_to :photo, counter_cache: true
  belongs_to :author, class_name: "User"
end
