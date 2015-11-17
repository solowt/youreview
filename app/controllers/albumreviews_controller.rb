class AlbumreviewsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  def index
    @reviews = Review.where(category: "Album")
  end
  def show
    @review = Review.find(params[:id])
    @info = Work.find(@review.work_id).apidata
  end
  def new
    @index = params[:work_id]
    @albumreview = Review.new
  end
  def create
    @review = current_user.reviews.create(review_params)
    @review.update(category: "Album", work_id: params[:work_id], name: Work.find(params[:work_id]).apidata["name"])
    redirect_to albumreview_path (@review)
  end
  def destroy
  end
  def edit
  end
  def update
  end
  def review_params
    params.require(:review).permit(:text, :title, :score)
  end
end
