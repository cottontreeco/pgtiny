class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user, only: :destroy
  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to cache_url
    else
      #failed to create the post make the feeds blank
      @feed_items = []
      render 'cache/index'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to cache_url
  end

  private
    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to cache_url if @micropost.nil?

    #if we use find, exception is raised if post not found
    #  @micropost = current_user.microposts.find(params[:id])
    #rescue
    #  redirect_to cache_url

    #if we check the user of the post, it has security concerns
    #@micropost = Micropost.find_by_id(params[:id])
    #redirect_to cache_url unless current_user?(@micropost.user)
    end
end