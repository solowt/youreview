class BookreviewsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  def index
    #all book reviews for the index
    @bookreviews = Bookreview.all
  end
  def show
    #select a specific review for the show page
    @bookreview = Bookreview.find(params[:id])
    @comments = @bookreview.comments #select comments
    @info = Bookwork.find(@bookreview.bookwork_id) #info will be the api response from goodreads, which is stored in the the booksworks table in the db
    #this is a lsit of all books by the author in question, for display on the
    #show page
    @book_list = HTTParty.get("https://www.goodreads.com/author/list/#{@info.author_id}?format=xml&key=#{ENV['goodread_key']}")['GoodreadsResponse']['author']['books']['book']
  end
  def new
    #placeholder review
    @bookreview = Bookreview.new
  end
  def create
    #create a new review
    @bookreview = current_user.bookreviews.new(review_params)
    #make an api call based on the title of the book
    book_info = HTTParty.get("https://www.goodreads.com/search.xml?key=#{ENV['goodread_key']}&q=#{@bookreview.name}")['GoodreadsResponse']['search']['results']['work'][0]['best_book']
    #create a new work, add information fromt he api call to the new work
    #I used the unique id to see if I already have this book in my DB.
    @new_work = Bookwork.find_or_create_by(unique_id: book_info['id'])
    #if I didn't have the book, AKA the bookwork title column is empty, I need to fill up the new work object
    if (!@new_work.title)
      @new_work.update(unique_id: book_info['id'], image_url: book_info['image_url'], title: book_info['title'], author: book_info['author']['name'], author_id: book_info['author']['id'])
    end
    #add some information from the bookwork table to the review table, for easier access.
    #I don't think this was necessary
    @bookreview.update(bookwork_id: @new_work.id, category: "Book", photo_url: @new_work.image_url)
    #check to see if it saves and flash messages
    if @bookreview.save
      flash[:notice] = "Review was successfully created."
        redirect_to @bookreview
    else
      flash[:alert] = "Review creation failed, likely missing a needed field."
      render :new
    end
  end
  def destroy
    #destroy a specific review
    @bookreview = Bookreview.find(params[:id])
    @bookreview.destroy
    redirect_to bookreviews_path
  end
  def edit
    #select a review to edit
    @bookreview = Bookreview.find(params[:id])
  end
  def update
    #update a new review based on user input params
    @bookreview = Bookreview.find(params[:id])
    @bookreview.update(review_params)
    redirect_to bookreview_path(@bookreview)
  end
  private
  #strong params
  def review_params
    params.require(:bookreview).permit(:text, :title, :score, :name)
  end
end
