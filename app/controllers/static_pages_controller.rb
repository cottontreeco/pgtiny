class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @feed_items = current_user.feed_from_following_user.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def signup
  end
end
