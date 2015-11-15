class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end
  def show
    @review = Review.find(params[:id])
    @movie_info = HTTParty.get("http://www.omdbapi.com/?t=#{@review.title}&plot=short&r=json")    
  end
  def new
  end
  def create
  end
  def destroy
  end
  def edit
  end
  def update
  end
end
