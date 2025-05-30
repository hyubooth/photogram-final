# == Schema Information
#
# Table name: photos
#
#  id             :bigint           not null, primary key
#  caption        :text
#  comments_count :integer
#  image          :string
#  likes_count    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :integer
#
class Photo < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many   :comments, dependent: :destroy # Good to add dependent: :destroy
  has_many   :likes, dependent: :destroy    # Good to add dependent: :destroy
  has_many   :fans, through: :likes, source: :fan

  # --- ADD THIS LINE ---
  has_one_attached :image
  # --- END OF ADDED LINE ---

  def image_identifier
    if self.image.attached?
      self.image.filename.to_s
    else
      nil # Or an empty string, depending on what the old test might have relied on for missing images
    end

    
  end

  validates :owner, presence: true
  # You might want to add a validation for the image later
  # validates :image, presence: true # <--- Add this later if needed
end
