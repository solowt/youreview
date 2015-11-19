class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  def index
    #all movie reviews so they may be displayed on the index page
    @reviews = Review.where(category: "Movie")
  end
  def show
    #select specifc review for show page
    @review = Review.find(params[:id])
    @comments = @review.comments #comments related to that review
    @info = Moviework.find(@review.work_id) #the work table that the review is attached to
  end
  def new
    #placeholder review, renders form
    @review = Review.new
  end
  #create method for movie reviews
  def create
    @review = current_user.reviews.new(review_params) #create empty new review
    #query TMDB api for information about the input title
    movie_info = Tmdb::Search.movie("#{@review.name}")['results'][0]
    #find or create a new work based on the unique ID provided by TMDB
    @new_work = Moviework.find_or_create_by(unique_id: movie_info['id'])
    #if the work did not already exist and we just created it, it won't have a title
    #so I used the title column to check for this.  If we did create it, we fill it up
    #with information from the api call here.
    if (!@new_work.title)
      @new_work.update(overview: movie_info['overview'], medium: "Movie", release_date: movie_info['release_date'], unique_id: movie_info['id'], original_title: movie_info['original_title'], backdrop_path: movie_info['backdrop_path'], vote_avg: movie_info['vote_average'], poster_path: movie_info['poster_path'], title: movie_info['title'])
    end
    #add some information from the work to the review
    @review.update(work_id: @new_work.id, category: "Movie", photo_url: @new_work['poster_path'])
    #check to see if it saved properly
    if @review.save
      flash[:notice] = "Review was successfully created."
        redirect_to @review
    else
      flash[:alert] = "Review creation failed, likely missing a needed field."
      render :new
    end
  end
  #destroy a specific review
  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to reviews_path
  end
  #select a review to edit
  def edit
    @review = Review.find(params[:id])
  end
  #update a review based on user params here
  def update
    @review = Review.find(params[:id])
    @review.update(review_params)
    redirect_to review_path(@review)
  end
  private
  #strong params
  def review_params
    params.require(:review).permit(:text, :title, :score, :name, :category)
  end
  def work_params
    params.require(:review).permit(:name)
  end
end
