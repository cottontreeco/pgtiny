class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @feed_items = current_user.reviewer_feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def signup
  end
end
