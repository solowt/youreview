class CommentsController < ApplicationController
  # NHO: How could you utilize nested resources to make these actions more RESTful?
  before_action :authenticate_user!, except: [:show, :index]
  #create a new comment.  this is used for album reviews and movie reviews
  def new
    @review = Review.find(params[:review_id])
    @comment = Comment.new
  end
  #this is used for comments on book reviews only.  I used a custom path
  #to get to this method
  def new_book_comment
    @bookreview = Bookreview.find(params[:bookreview_id])
    @comment = Comment.new
  end
  #again, this is the create method only for comments on bookreviews.  used a
  #custom path to get here
  def post_book_comment
    @bookreview = Bookreview.find(params[:bookreview_id])
    @comment = @bookreview.comments.create!(comment_params)
    @comment.update(user_id: current_user.id)
    redirect_to bookreview_path(@bookreview)
  end
  #this is where we destroy only comments on book reviews.  custom path was used.
  def destroy_book_comment
    @bookreview = Bookreview.find(params[:bookreview_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to bookreview_path(@bookreview)
  end
  #creation method for album reviews and movie reviees.
  #checks for category so it knows where to redirect
  def create
    @review = Review.find(params[:review_id])
    @comment = @review.comments.create(comment_params)
    @comment.update(user_id: current_user.id)
    if (@review.category == "Album")
      redirect_to albumreview_path(@review)
    elsif (@review.category == "Movie")
      redirect_to review_path(@review)
    end
  end
  #destroy method for cocmments, again uses if statement to check for album or movie
  #review
  def destroy
    @review = Review.find(params[:review_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    if (@review.category == "Album")
      redirect_to albumreview_path(@review)
    elsif (@review.category == "Movie")
      redirect_to review_path(@review)
    end
  end
  #edit method for album/movie reviews
  def edit
    @review = Review.find(params[:review_id])
    @comment = Comment.find(params[:id])
  end
  #update method for album/movie reviews
  def update
    @review = Review.find(params[:review_id])
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
    if (@review.category == "Album")
      redirect_to albumreview_path(@review)
    elsif (@review.category == "Movie")
      redirect_to review_path(@review)
    end
  end
  private
  #strong params
  def comment_params
    params.require(:comment).permit(:text, :title)
  end
end
