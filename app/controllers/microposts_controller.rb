class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      render 'static_pages/cache'
    end
  end

  def destroy

  end
end