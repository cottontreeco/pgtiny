class UsersController < ApplicationController
  #requires sign in before updating or editing a user
  before_filter :signed_in_user, only: [:index, :edit, :update]
  #require the right user to be signed in
  before_filter :correct_user, only: [:edit, :update]
  # GET /users
  # GET /users.json
  def index
    @users = User.order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    # after using before filter, this is no longer needed
    # @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        sign_in @user
        flash[:success] = "#{@user.name}, Welcome to the Tiny App!"
        # redirect to user index page
        format.html { redirect_to @user }
        format.json { render json: @user,
                             status: :created,
                             location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors,
                             status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        sign_in @user
        # redirect to user index page
        format.html {
          redirect_to user_url,notice: "Profile updated successfully for user #{@user.name}."
        }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors,
                             status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(cache_path) unless current_user?(@user)
    end
end
