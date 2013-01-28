class CacheController < ApplicationController
  def index
    @gears = Gear.all
    if signed_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def about

  end
end
