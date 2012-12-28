class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email].downcase)
    if user && user.authenticate(params[:password])
      # Sign the user in and redirect to the user's show page
      sign_in user
      #session[:user_id] = user.id
      redirect_back_or user
    else
      # Create an error message and re-render the signin form
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
      #redirect_to signin_url
    end
  end

  def destroy
    sign_out
    redirect_to cache_url, notice: "Logged out"
  end
end
