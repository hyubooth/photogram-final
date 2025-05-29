class PhotosController < ApplicationController
  # Make sure user is signed in for actions that need it
  before_action :authenticate_user!, except: [:index, :show]
  # Skip for index only if you want anyone to see it
  # skip_before_action :authenticate_user!, only: [:index]

  def index
    @list_of_photos = Photo.all.order({ created_at: :desc })
    # For the upload form (if it's on the index page)
    @photo = Photo.new
    render({ template: "photos/index" })
  end

  def show
    @the_photo = Photo.find(params[:id]) # Use find for simplicity
    render({ template: "photos/show" })
  rescue ActiveRecord::RecordNotFound
    redirect_to photos_path, alert: "Photo not found."
  end

  def create
    # Build the photo through the current_user's association
    @photo = current_user.photos.build(photo_params)

    Rails.logger.info "--- Attempting to save photo: #{@photo.inspect} ---"

    if @photo.save
      Rails.logger.info "--- SUCCESS! Photo saved. ---"
      redirect_to photos_path, notice: "Photo created successfully."
    else
      Rails.logger.error "--- FAILED! Errors: #{@photo.errors.full_messages.to_sentence} ---"
      # IMPORTANT: If save fails, re-render the form to show errors
      @list_of_photos = Photo.all.order({ created_at: :desc }) # Reload for index
      flash.now[:alert] = "Could not add photo: #{@photo.errors.full_messages.to_sentence}"
      render :index # Re-render the index template (or :new if you have a separate new page)
    end
  end

  def update
    @the_photo = Photo.find(params[:id]) # Use :id now

    # Check if the current user owns the photo before updating
    if @the_photo.owner == current_user
      if @the_photo.update(photo_params_for_update) # Use photo_params
        redirect_to photo_path(@the_photo), notice: "Photo updated successfully."
      else
        render :edit, alert: "Update failed: #{@the_photo.errors.full_messages.to_sentence}"
      end
    else
      redirect_to photo_path(@the_photo), alert: "You are not authorized to edit this photo."
    end
  end

  def destroy
    @the_photo = Photo.find(params[:id]) # Use :id now

    # Check if the current user owns the photo before deleting
    if @the_photo.owner == current_user
      @the_photo.destroy
      redirect_to photos_path, notice: "Photo deleted successfully."
    else
      redirect_to photo_path(@the_photo), alert: "You are not authorized to delete this photo."
    end
  end

  private

  def photo_params
    # It MUST use .require(:photo) because you use form_with(model: @photo)
    params.require(:photo).permit(:image, :caption)
  end

  # You might need slightly different params for update
  def photo_params_for_update
     params.require(:photo).permit(:image, :caption)
     # Or params.permit(:image, :caption)
  end
end
