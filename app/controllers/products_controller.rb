class ProductsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create]
  before_action :admin_user, only: [:destroy, :edit, :update]
  # GET /products
  # GET /products.json
  def index
    @products = Product.paginate(page: params[:page])

    respond_to do |format|
      format.html # index.html.delete.erb
      format.json { render json: @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])
    @reviews = @product.reviews.paginate(page: params[:page])
    if signed_in?
      @review = @reviews.where(user_id: current_user.id).first
      if @review.nil?
        @review = Review.new(product_id: @product.id, user_id: current_user.id)
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(product_params)
        flash[:success] = "Product updated"
        format.html { redirect_to @product} # notice: 'Product was successfully updated.'
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  private

  def product_params
    params.require(:product).permit(:photo, :name)
  end
end
