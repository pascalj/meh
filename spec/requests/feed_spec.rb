require 'spec_helper'

describe "podcast feed" do
  before :each do
    @podcast = FactoryGirl.create(:podcast)
    @episode = FactoryGirl.create(:episode, :scheduled, finished_at: Time.now, podcast: @podcast)
    get podcast_path(@podcast, format: :rss)
  end

  it "sets the title of the podcast" do
    response.body.should have_xpath('/rss/channel/title').with_text(@podcast.name)
  end

  it "links to the current podcast" do
    response.body.should have_xpath('/rss/channel/link').with_text(podcast_url(@podcast))
  end

  it "outputs the last episodes" do
    response.body.should have_xpath('/rss/channel/item')
  end
end