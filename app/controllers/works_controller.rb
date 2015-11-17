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
    RSpotify.raw_response = true
    @work_array = Work.create(title: "albumlist")
    puts params.inspect
    api_response = RSpotify::Album.search(params[:work][:title])
    @work_array.update(apidata: api_response)
    redirect_to work_path @work_array
  end
  def show
    #from the links we create in views we will
    #redirect to a specific work and index to decide
    #on an album
    @works_array = Work.find(params[:id])
  end
  def select
    @works_array = Work.find(params[:work_id])
    @api_info = @works_array.apidata["albums"]["items"][params[:work_index].to_i]
    @new_work = Work.create(apidata: @api_info)
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
