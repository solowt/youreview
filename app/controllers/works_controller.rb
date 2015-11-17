class WorksController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  def index
  end
  def show
  end
  def new
    @work = Work.new
  end
  def create
    RSpotify.raw_response = false
    work_array =  RSpotify::Artist.search(params[:work][:title])
    artist = work_array.first
    albums = artist.albums
    album_array = Work.create(title: params[:work][:title], medium: "albumlist", apidata: albums)
    redirect_to work_path album_array
  end
  def show
    #from the links we create in views we will
    #redirect to a specific work and index to decide
    #on an album
    @works_array = Work.find(params[:id])
  end
  def select
    works_array = Work.find(params[:work_id])
    api_info = works_array.apidata[params[:work_index].to_i]
    @new_work = Work.find_or_create_by(unique_id: api_info["id"].to_s)
    if !@new_work.apidata
      @new_work.update(medium: "Album", title: works_array.title, apidata: api_info)
    end
    Work.where(medium: "albumlist").destroy_all
    redirect_to new_work_albumreview_path (@new_work)
  end
  def destroy
  end
  def edit
  end
  def update
  end
  private
  def album_params
    params.require(:work).permit(:title)
  end
end
