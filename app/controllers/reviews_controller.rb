class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  def index
    #order movies here .order_by
    @reviews = Review.where(category: "Movie")
  end
  def show
    @review = Review.find(params[:id])
    @comments = @review.comments
    @info = Moviework.find(@review.work_id)
  end
  def new
    @review = Review.new
  end
  def create
    @review = current_user.reviews.new(review_params)

    movie_info = Tmdb::Search.movie("#{@review.name}")['results'][0]
    @new_work = Moviework.find_or_create_by(unique_id: movie_info['id'])
    if (!@new_work.title)
      @new_work.update(overview: movie_info['overview'], medium: "Movie", release_date: movie_info['release_date'], unique_id: movie_info['id'], original_title: movie_info['original_title'], backdrop_path: movie_info['backdrop_path'], vote_avg: movie_info['vote_average'], poster_path: movie_info['poster_path'], title: movie_info['title'])
    end
    @review.update(work_id: @new_work.id, category: "Movie", photo_url: @new_work['poster_path'])

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
