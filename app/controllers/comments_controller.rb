class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  def new
    @review = Review.find(params[:review_id])
    @comment = Comment.new
  end
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
  def edit
    @review = Review.find(params[:review_id])
    @comment = Comment.find(params[:id])
  end
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
  def comment_params
    params.require(:comment).permit(:text, :title)
  end
end
