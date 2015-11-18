class BookreviewsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  def index
    @bookreviews = Bookreview.where(category: "Book")
  end
  def show
    @bookreview = Bookreview.find(params[:id])
    @comments = @bookreview.comments
    @info = Bookwork.find(@bookreview.bookwork_id)
  end
  def new
    @bookreview = Bookreview.new
  end
  def create
    @bookreview = current_user.bookreviews.new(review_params)
    book_info = HTTParty.get("https://www.goodreads.com/search.xml?key=#{ENV["goodread_key"]}&q=#{@bookreview.name}")['GoodreadsResponse']['search']['results']['work'][0]['best_book']
    @new_work = Bookwork.find_or_create_by(unique_id: book_info['id'])
    if (!@new_work.title)
      @new_work.update(unique_id: book_info['id'], image_url: book_info['image_url'], title: book_info['title'], author: book_info['author']['name'])
    end
    @bookreview.update(bookwork_id: @new_work.id, category: "Book", photo_url: @new_work.image_url)

    if @bookreview.save
      flash[:notice] = "Review was successfully created."
        redirect_to @bookreview
    else
      flash[:alert] = "Review creation failed, likely missing a needed field."
      render :new
    end

  end
  def destroy
    @bookreview = Bookreview.find(params[:id])
    @bookreview.destroy
    redirect_to bookreviews_path
  end
  def edit
    @bookreview = Bookreview.find(params[:id])
  end
  def update
    @bookreview = Bookreview.find(params[:id])
    @bookreview.update(review_params)
    redirect_to bookreview_path(@bookreview)
  end
  def review_params
    params.require(:bookreview).permit(:text, :title, :score, :name)
  end
end
