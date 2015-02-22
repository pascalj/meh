require 'spec_helper'

describe "podcast feed" do
  before :each do
    @podcast = FactoryGirl.create(:podcast)
    @episode = FactoryGirl.create(:episode, :scheduled, finished_at: Time.now, podcast: @podcast)
    allow(File).to receive(:size).and_return(150)
    get podcast_path(@podcast, format: :rss)
  end

  it "sets the title of the podcast" do
    expect(response.body).to have_xpath('/rss/channel/title').with_text(@podcast.name)
  end

  it "links to the current podcast" do
    expect(response.body).to have_xpath('/rss/channel/link').with_text(podcast_url(@podcast))
  end

  it "outputs the last episodes" do
    expect(response.body).to have_xpath('/rss/channel/item')
  end

  it "sets the enclosure" do
    expect(response.body).to have_xpath('/rss/channel/item/enclosure')
  end
end