class PodcastsController < ApplicationController
  def index
    @podcasts = Podcast.all
  end

  def new
    @podcast = Podcast.new
  end

  def show
    @podcast = Podcast.friendly.find(params[:id])
    @episodes = Episode.finished.where(podcast: @podcast)
  end

  def create
    @podcast = Podcast.new(podcast_params)
    @podcast.valid?
    if @podcast.save
      redirect_to @podcast
    else
      render :new
    end
  end

  def edit
    @podcast = Podcast.friendly.find(params[:id])
  end

  def update
    @podcast = Podcast.friendly.find(params[:id])
    if @podcast.update(podcast_params)
      redirect_to @podcast
    else
      render :edit, podcast: @podcast
    end
  end

  def destroy
    @podcast = Podcast.friendly.find(params[:id])
    @podcast.destroy!
    redirect_to action: :index
  end

  private

  def podcast_params
    params.require(:podcast).permit(:name, :length, :stream, :stream_id, :start_at, :day_of_week)
  end
end
