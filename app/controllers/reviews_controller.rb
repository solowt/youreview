class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end
  def show


    # all this will be in the create method.  the
    # show method will access the review and its associated
    # subject
    @review = Review.find(params[:id])
    if @review.category.downcase == "film" || "movie" || "show" || "tv show" || "series"
      @movie_info = HTTParty.get("http://www.omdbapi.com/?t=#{@review.name}&plot=short&r=json")
    elsif @review.category.downcase == "album"
      RSpotify.raw_response = true
      @album_info = RSpotify::Album.search("#{@review.name}")
    end

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
