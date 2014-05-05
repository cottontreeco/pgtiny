class ReviewsController<ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]

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

  end

  private
  def review_params
    params.require(:review).permit(:user_id, :product_id, :remark)
  end
end