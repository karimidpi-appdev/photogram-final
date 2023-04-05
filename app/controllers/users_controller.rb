class UsersController < ApplicationController
  def index
    matching_users = User.all

    @list_of_users = matching_users.order({ :created_at => :desc })

      render({ :template => "users/index.html.erb" })
  end

  def show
    the_username = params.fetch("the_username")
    matching_users = User.where({ :username => the_username })
    @user = matching_users.at(0)

    matching_follow_requests = FollowRequest.all

    @list_of_follow_requests = matching_follow_requests.order({ :created_at => :desc })

    if @current_user == nil
      redirect_to("/user_sign_in", { :notice => "You have to sign in first." })
    else
      render({ :template => "users/show.html.erb" })
    end
  end

  def liked_photos
    @photos = @current_user.liked_photos

    render({ :template => "users/liked_photos.html.erb" })
  end

  def feed
    render({ :template => "users/feed.html.erb" })
  end

  def discover
    render({ :template => "users/discover.html.erb" })
  end
end
