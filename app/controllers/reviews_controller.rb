class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  def index
    @reviews = Review.where(category: "Movie")
  end
  def indexalbums
    @reviews = Review.where(category: "Book")
  end
  def indexbooks
    @reviews = Review.where(category: "Album")
  end
  def show


    # all this will be in the create method.  the
    # show method will access the review and its associated
    # subject
    @review = Review.find(params[:id])
    @info = Work.find(@review.work_id).apidata
  end
  def new
    @review = Review.new
  end
  def create

    @review = current_user.reviews.new(review_params)


    if @review.category == "Movie"
      movie_info = HTTParty.get("http://www.omdbapi.com/?t=#{@review.name}&plot=short&r=json")
      @new_work = Work.create(title: @review.name, medium: "Movie", apidata: movie_info)
      @review.update(work_id: @new_work.id)
    # books and albums here
    # elsif @review.category.downcase == "album"
    #   RSpotify.raw_response = true
    #   @album_info = RSpotify::Album.search("#{@review.name}")
    # elsif @review.category.downcase == "album"

    end

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
