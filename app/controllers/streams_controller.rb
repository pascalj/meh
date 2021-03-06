class StreamsController < ApplicationController
  def index
    @streams = Stream.all
  end

  def new
    @stream = Stream.new
  end

  def show
    redirect_to controller: :podcasts, action: :index, id: nil
  end

  def create
    @stream = Stream.new(stream_params)
    @stream.valid?
    if @stream.save
      redirect_to @stream
    else
      render :new
    end
  end

  def update
    @stream = Stream.friendly.find(params[:id])
    if @stream.update(stream_params)
      redirect_to @stream
    else
      render :edit, stream: @stream
    end
  end


  private

  def stream_params
    params.require(:stream).permit(:name, :url)
  end
end
