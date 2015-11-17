class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  def index
    @reviews = Review.where(category: "Movie")
  end
  def show
    @review = Review.find(params[:id])
    @info = Work.find(@review.work_id).apidata
  end
  def new
    @review = Review.new
  end
  def create
    puts "*"*400
    @review = current_user.reviews.new(review_params)

    movie_info = HTTParty.get("http://www.omdbapi.com/?t=#{@review.name}&plot=short&r=json")
    @new_work = Work.find_or_create_by(title: @review.name)
    if !@new_work.apidata
      @new_work.update(apidata: movie_info, medium: @review.category)
    end
    @review.update(work_id: @new_work.id)

    if @review.save
      flash[:notice] = "Review was successfully created."
        redirect_to @review
    else
      flash[:alert] = "Review creation failed, likely missing a needed field."
      render :new
    end
  end
  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to reviews_path
  end
  def edit
    @review = Review.find(params[:id])
  end
  def update
    @review = Review.find(params[:id])
    @review.update(review_params)
    redirect_to review_path(@review)
  end
  private
  def review_params
    params.require(:review).permit(:text, :title, :score, :name, :category)
  end
  def work_params
    params.require(:review).permit(:name)
  end
end
