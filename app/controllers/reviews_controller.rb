class ReviewsController<ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def index

  end

  def create
    @review = Review.new(review_params)
    @product = Product.find(@review.product_id)
    if @review.save
      flash[:success] = "Review created!"
      redirect_to @product
    else
      @reviews = @product.reviews.paginate(page: params[:page])
      render template: "products/show"
    end
  end

  def destroy
    @review.destroy
    redirect_to root_url
  end

private
  def review_params
    params.require(:review).permit(:user_id, :product_id, :remark)
  end
  def correct_user
    @review = current_user.reviews.find_by(id: params[:id])
    redirect_to root_url if @review.nil?
  end
end