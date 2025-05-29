# app/controllers/likes_controller.rb
class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_photo, only: [:create]
  before_action :set_like, only: [:destroy]

  def create
    # Check if already liked to prevent duplicates (optional but good)
    if current_user.likes.exists?(photo_id: @photo.id)
      redirect_to @photo, alert: "You already liked this photo."
      return
    end

    @like = @photo.likes.build(fan: current_user)

    if @like.save
      redirect_to @photo, notice: "Photo liked!"
    else
      redirect_to @photo, alert: "Could not like photo."
    end
  end

  def destroy
    # Ensure the like exists and belongs to the current user
    if @like && @like.fan == current_user
      photo = @like.photo # Get the photo before destroying the like
      @like.destroy
      redirect_to photo, notice: "Photo unliked."
    else
      redirect_to root_path, alert: "Could not find your like to unlike."
    end
  end

  private

  def set_photo
    @photo = Photo.find(params[:photo_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Photo not found."
  end

  def set_like
    @like = Like.find_by(id: params[:id]) # Use find_by to avoid errors
  end
end
