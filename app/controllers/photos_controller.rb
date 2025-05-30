# app/controllers/photos_controller.rb
class PhotosController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_photo, only: [:show, :edit, :update, :destroy] # Add :edit here
  before_action :authorize_owner, only: [:edit, :update, :destroy] # New action for authorization

# photos_controller.rb

  def index
    # Only show photos from users who are not private
    @list_of_photos =
      if user_signed_in?
        Photo.joins(:owner)
            .where("users.private = ? OR users.id = ?", false, current_user.id)
            .order(created_at: :desc)
      else
        Photo.joins(:owner).where(users: { private: false }).order(created_at: :desc)
      end


    @photo = Photo.new
  end


  def show
    # @the_photo is set by before_action :set_photo
    # render({ template: "photos/show" }) # Implicitly renders show.html.erb
    @the_photo = Photo.find(params[:id])

  end

  # GET /photos/new (if you want a separate new page, otherwise form is on index)
  # def new
  #   @photo = current_user.photos.build
  # end

  def create
    @photo = current_user.photos.build(photo_create_params)

    if @photo.save
      redirect_to photos_path, notice: "Photo created successfully."
    else
      # If create fails, re-render the form with errors
      @list_of_photos = Photo.all.order({ created_at: :desc }) # For index page form
      flash.now[:alert] = "Could not add photo: #{@photo.errors.full_messages.join(', ')}"
      render :index, status: :unprocessable_entity
    end
  end

  # GET /photos/:id/edit (This action is needed for an edit page)
  def edit
    # @the_photo is set by before_action :set_photo
    # @the_photo is authorized by before_action :authorize_owner
    # render({ template: "photos/edit" }) # Implicitly renders edit.html.erb
    # If your edit form is on the show page, you might not need a separate edit action/view.
    # However, the form you added to show.html.erb was a manual HTML form.
    # Using a dedicated edit action and view with form_with is more standard.
    # For now, let's assume your edit form remains on the show page.
  end

  def update
    # @the_photo is set by before_action :set_photo
    # @the_photo is authorized by before_action :authorize_owner

    if @the_photo.update(photo_update_params)
      redirect_to photo_path(@the_photo), notice: "Photo updated successfully."
    else
      # If you had a separate edit page:
      # render :edit, status: :unprocessable_entity
      # If form is on show page, handling errors by re-rendering show is complex.
      # A redirect with an alert is simpler if not using Turbo.
      redirect_to photo_path(@the_photo), alert: "Update failed: #{@the_photo.errors.full_messages.to_sentence}"
    end
  end

  def destroy
    # @the_photo is set by before_action :set_photo
    # @the_photo is authorized by before_action :authorize_owner

    @the_photo.destroy
    redirect_to photos_path, notice: "Photo deleted successfully."
  end

  private

  def set_photo
    @the_photo = Photo.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to photos_path, alert: "Photo not found."
  end

  def authorize_owner
    unless @the_photo.owner == current_user
      redirect_to photo_path(@the_photo), alert: "You are not authorized to perform this action."
    end
  end

  # Strong parameters for creating a photo
  def photo_create_params
    # This assumes your NEW photo form (form_with(model: @photo)) sends params[:photo][:image] etc.
    params.require(:photo).permit(:image, :caption)
  end

  # Strong parameters for updating a photo
  def photo_update_params
    # This assumes your EDIT photo form (form_with(model: @the_photo)) sends params[:photo][:image] etc.
    # If the image is optional on update, it will work fine.
    # If :image is not sent, it won't be updated.
    params.require(:photo).permit(:caption, :image)
  end
end
