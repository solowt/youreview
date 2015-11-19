class AlbumreviewsController < ApplicationController
  #authenticate user
  before_action :authenticate_user!, except: [:show, :index]
  def index
    #all reviews with the category Album for the index page
    @reviews = Review.where(category: "Album")
  end
  def show
    @review = Review.find(params[:id]) #specific review to show
    @comments = @review.comments #comments belonging to that review
    @info = Work.find(@review.work_id) #the work being reviewed
    @tracks = RSpotify::Album.find(@info.unique_id).tracks #use spotify api to find tracks on the album being reviewed
  end
  def new
    #here the index is not the work id, it's actually
    #the index of the array of albums that the user has selected
    #we use this index to select a specific album from the list
    #there's definitely a better way to do this.
    @index = params[:work_id]
    #placeholder review
    @albumreview = Review.new
  end
  def create
    #here we relate the album that the user has chosen to the review
    #that is being generated
    work = Work.find(params[:work_id]).apidata
    #attach current user to the new review
    @review = current_user.reviews.create(review_params)
    #add some information from spotify api's response to the
    #review, this is probably not needed, it just allows me to
    #access some information from the review without going through
    #the api response elsewhere
    @review.update(category: "Album", work_id: params[:work_id], name: work["name"], photo_url: work['images'][0]['url'])
    redirect_to albumreview_path (@review)
  end
  def destroy
    #destroy an album review
    @albumreview = Review.find(params[:id])
    @albumreview.destroy
    redirect_to albumreviews_path
  end
  def edit
    #select a review to edit
    @albumreview = Review.find(params[:id])
  end
  def update
    #update and redirect based on params
    @albumreview = Review.find(params[:id])
    @albumreview.update(review_params)
    redirect_to albumreview_path(@albumreview)
  end
  private
  #strong params for album reviews
  def review_params
    params.require(:review).permit(:text, :title, :score)
  end
end
