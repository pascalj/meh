require 'spec_helper'

describe Episode do
  it "requires a stream" do
    Episode.new.should_not be_valid
  end

  it "is valid with a stream" do
    FactoryGirl.build(:episode).should be_valid
  end
end
