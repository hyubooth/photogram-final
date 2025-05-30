class FollowRequestsController < ApplicationController
  def index
    matching_follow_requests = FollowRequest.all

    @list_of_follow_requests = matching_follow_requests.order({ :created_at => :desc })

    render({ :template => "follow_requests/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_follow_requests = FollowRequest.where({ :id => the_id })

    @the_follow_request = matching_follow_requests.at(0)

    render({ :template => "follow_requests/show" })
  end

  def create
    follow_request = FollowRequest.new
    follow_request.recipient_id = params[:query_recipient_id]
    follow_request.sender_id = params[:query_sender_id]
    follow_request.status = params[:query_status]

    if follow_request.save
      redirect_to("/users")
    else
      render plain: "Failed to follow: #{follow_request.errors.full_messages.join(", ")}"
    end
  end


  def update
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :id => the_id }).at(0)

    the_follow_request.sender_id = params.fetch("query_sender_id")
    the_follow_request.recipient_id = params.fetch("query_recipient_id")
    the_follow_request.status = params.fetch("query_status")

    if the_follow_request.valid?
      the_follow_request.save
      redirect_to("/follow_requests/#{the_follow_request.id}", { :notice => "Follow request updated successfully."} )
    else
      redirect_to("/follow_requests/#{the_follow_request.id}", { :alert => the_follow_request.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :id => the_id }).at(0)

    the_follow_request.destroy

    if request.referer.present?
      redirect_to(request.referer)
    else
      redirect_to("/follow_requests", { :notice => "Follow request deleted successfully." })
    end
  end
end
