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
end
