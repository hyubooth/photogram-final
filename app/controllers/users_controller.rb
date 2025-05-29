class UsersController < ApplicationController
  
  skip_before_action(:authenticate_user!, only: [:index, :show, :liked_photos, :feed, :discover])
  #has_many :likes, foreign_key: "fan_id"

  # Checks if this user has liked a specific photo
  def has_liked?(photo)
    # Ensure both self.id and photo.id are not nil before checking
    return false unless self.id && photo&.id
    Like.exists?(fan_id: self.id, photo_id: photo.id)
  end

  # Finds the ID of the like this user made for a specific photo
  def find_like_for(photo)
    # Ensure both self.id and photo.id are not nil before checking
    return nil unless self.id && photo&.id
    likes.find_by(photo_id: photo.id)
  end
  #index
  def index
    render({:template => "users/index"})
  end 

  def show
    @this_user = User.where(username: params[:id]).first

    if current_user_can_view_details?(@this_user)
      render({ template: "users/show" })
    else
      redirect_to("/users", notice: "You are not authorized to do that!")
    end
  end
 
  
  def liked_photos
    @this_user = User.where(:username => params.fetch("username")).first
    render({:template => "users/liked_photos"})
  end 
  
  def feed
    @this_user = User.where(:username => params.fetch("username")).first
    @all_leaders = @this_user.follow_sent.where(:status => "accepted").pluck(:recipient_id)
    @all_leader_photos = Photo.where(owner_id: @all_leaders)

    render({:template => "users/feed"})
  end

  def discover
    @this_user = User.where(:username => params.fetch("username")).first
    @all_leaders = User.where(id: @this_user.follow_sent.where(:status => "accepted").pluck(:recipient_id))
    @all_leader_likes = Like.where(fan_id: @all_leaders.pluck(:id))
    @all_leader_liked_photos = Photo.where(id: @all_leader_likes.pluck(:photo_id))

    render({:template => "users/discover"})
  end 

  def current_user_can_view_details?(user)
    return false if user.nil? # Add this line
    return false if current_user.nil?
    return true if current_user.id == user.id
    return true if user.private == false
    return true if user.private == true &&
                  current_user.follow_sent.where(status: "accepted", recipient_id: user.id).present?
    return false
  end




  def edit
    render({:template => "devise/registration/edit"})
  end

end
