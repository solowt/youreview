class WorksController < ApplicationController
  # NHO: AlbumWorks: could consider moving the api calls out of the controller and into custom methods on our model, or seperate model.
  before_action :authenticate_user!, except: [:show, :index]
  #note: the works controller is ONLY used for creating albumreviews.
  #this is the case because spotify's api was too inaccuate when it came to
  #searching for albums by title.  I had to search for artist and instead give a list
  #of albums per artist (20 albums per seach only) the user then selects an album
  #from this list, a work is created, and then the review is created based
  #on user input data and associated to that work

  #didn't use index, but I planned to so I still generated them.  maybe #add this later
  def index
  end
  #create placeholder work and render form
  def new
    @work = Work.new
  end
  #create an array of albums that is returned by the spotify api.  based on the
  #name of the artist which is input by the user
  def create
    RSpotify.raw_response = false
    #api call
    work_array =  RSpotify::Artist.search(params[:work][:title])
    #select the artist from the api call
    artist = work_array.first
    #make the array of albums
    albums = artist.albums
    #this is "fake" work, it doesn't refer to a specific album, rather it holds the array of albums (max 20).  this work will be deleted later
    #as its only real use is to help the user select an album later
    #there's definitely a better way to do this. and I want to refactor this part heavily
    album_array = Work.create(title: params[:work][:title], medium: "albumlist", apidata: albums)
    redirect_to work_path album_array
  end
  def show
    #here is where we display the array of albums for the user to pick from
    @works_array = Work.find(params[:id])
  end
  #custom method which is routed to using a custom path.  this where the user selects an album from
  #from the album array
  def select
    #find the arry
    works_array = Work.find(params[:work_id])
    api_info = works_array.apidata[params[:work_index].to_i] #construct the actual work here
    #find or create this work based on the unique ID from spotify
    @new_work = Work.find_or_create_by(unique_id: api_info["id"].to_s)
    #if it didn't previously exist, now we enter information
    if !@new_work.apidata
      @new_work.update(medium: "Album", title: works_array.title, apidata: api_info)
    end
    #destroy all album lists that were entered into the works table.  these won't be used again, so I cleared them out
    #again, there's definitely a better way to do this
    Work.where(medium: "albumlist").destroy_all
    #redirect
    redirect_to new_work_albumreview_path (@new_work)
  end
  #didn't use these methods # NHO: then delete them!
  def destroy
  end
  def edit
  end
  def update
  end
  private
  #strong params
  def album_params
    params.require(:work).permit(:title)
  end
end
