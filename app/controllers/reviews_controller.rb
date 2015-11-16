class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  def index
    @reviews = Review.all
  end
  def show


    # all this will be in the create method.  the
    # show method will access the review and its associated
    # subject
    @review = Review.find(params[:id])
    if @review.category.downcase == "movie" || "show"
      @movie_info = HTTParty.get("http://www.omdbapi.com/?t=#{@review.name}&plot=short&r=json")
    elsif @review.category.downcase == "album"
      RSpotify.raw_response = true
      @album_info = RSpotify::Album.search("#{@review.name}")
    end

  end
  def new
    @review = Review.new
  end
  def create
    @review = current_user.reviews.new(review_params)
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
end
