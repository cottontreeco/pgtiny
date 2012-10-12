class SessionsController < ApplicationController
  def new
  end

  def create
    if user = User.authenticate(params[:email], params[:pwd])
      session[:user_id] = user.id
      redirect_to admin_url
    else
      redirect_to login_url, alert: "Invalid email/password combination"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to cache_url, notice: "Logged out"
  end
end
