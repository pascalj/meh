# encoding: UTF-8

require 'spec_helper'

describe Podcast do

  it "requires a name" do
    podcast = Podcast.new
    expect(podcast).to be_invalid
  end

  it "requires a length > 0" do
    podcast = Podcast.new(name: 'my name')
    expect(podcast).to be_invalid
    expect(podcast.errors[:length]).to_not be_empty
  end

  it "must have a stream" do
    podcast = Podcast.new(name: 'my name', length: 15)
    expect(podcast).to be_invalid
    expect(podcast.errors[:stream]).to_not be_empty
  end

  describe "#schedule_recording" do

    before :each do
      allow(RecordWorker).to receive(:perform_at).and_return("JOB_ID")
    end

    it "adds episodes to record" do
      @today = FactoryGirl.create_list(:podcast, 5, :today)
      expect{
        Podcast.schedule_recording
      }.to change(Episode, :count).by(@today.length)
    end

    it "doesn't schedule an episode twice" do
      @today = FactoryGirl.create_list(:podcast, 5, :today)
      expect{
        Podcast.schedule_recording
        Podcast.schedule_recording
      }.to change(Episode, :count).by(@today.length)
    end

    it "schedules the recording at scheduled_at" do
      podcast = FactoryGirl.create(:podcast, :tomorrow)
      expect(RecordWorker).to receive(:perform_at)
      Podcast.schedule_recording
    end
  end

  describe "scope record_next" do
    before :each do
      @today = FactoryGirl.create_list(:podcast, 5, :today);
      @tomorrow = FactoryGirl.create_list(:podcast, 4, :tomorrow);
      @yesterday = FactoryGirl.create_list(:podcast, 3, :yesterday);
    end

    it "finds podcasts which should be recorded next" do
      expect(Podcast.record_next.count).to eq(@today.length + @tomorrow.length)
    end
  end

  describe "#save_name" do

    it "strips all but A-Za-z" do
      podcast = FactoryGirl.build(:podcast, name: 'MÖÄÜy42##2!$%&/1P0odcast66')
      expect(podcast.save_name).to eq('mypodcast')
    end
  end
end
