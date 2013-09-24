require 'spec_helper'

describe Podcast do

  it "requires a name" do
    podcast = Podcast.new
    podcast.valid?.should == false
  end

  it "requires a length > 0" do
    podcast = Podcast.new(name: 'my name')
    podcast.should be_invalid
    podcast.errors[:length].should_not be_empty
  end

  it "must have a stream" do
    podcast = Podcast.new(name: 'my name', length: 15)
    podcast.should be_invalid
    podcast.errors[:stream].should_not be_empty
  end

  describe "#schedule_recording" do
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
  end

  describe "scope record_next" do
    before :each do
      @today = FactoryGirl.create_list(:podcast, 5, :today);
      @tomorrow = FactoryGirl.create_list(:podcast, 4, :tomorrow);
      @yesterday = FactoryGirl.create_list(:podcast, 3, :yesterday);
    end

    it "finds podcasts which should be recorded next" do
      Podcast.record_next.count.should == @today.length + @tomorrow.length
    end
  end
end
