class AlbumreviewsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  def index
    @reviews = Review.where(category: "Album")
  end
  def show
    @review = Review.find(params[:id])
    @comments = @review.comments
    @info = Work.find(@review.work_id)
    @tracks = RSpotify::Album.find(@info.unique_id).tracks
  end
  def new
    @index = params[:work_id]
    @albumreview = Review.new
  end
  def create
    work = Work.find(params[:work_id]).apidata
    @review = current_user.reviews.create(review_params)
    @review.update(category: "Album", work_id: params[:work_id], name: work["name"], photo_url: work['images'][0]['url'])
    redirect_to albumreview_path (@review)
  end
  def destroy
    @albumreview = Review.find(params[:id])
    @albumreview.destroy
    redirect_to albumreviews_path
  end
  def edit
    @albumreview = Review.find(params[:id])
  end
  def update
    @albumreview = Review.find(params[:id])
    @albumreview.update(review_params)
    redirect_to albumreview_path(@albumreview)
  end
  def review_params
    params.require(:review).permit(:text, :title, :score)
  end
end
