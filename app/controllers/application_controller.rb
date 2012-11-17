class ApplicationController < ActionController::Base
  #before_filter :authorize
  protect_from_forgery
  include SessionsHelper

  protected

    def authorize
      unless User.find_by_id(session[:user_id])
        redirect_to login_url, notice: "Please log in"
      end
    end

  private

  def current_wish
    Wish.find(session[:wish_id])
  rescue ActiveRecord::RecordNotFound
    wish = Wish.create
    session[:wish_id] = wish.id
    wish
  end

end
