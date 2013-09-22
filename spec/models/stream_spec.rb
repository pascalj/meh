require 'spec_helper'

describe Stream do

  it "must have a name" do
    stream = Stream.new
    stream.valid?.should == false
  end

  it "must have a valid URL" do
    stream = Stream.new(name: 'My Stream', url: 'totally-no-url')
    stream.valid?.should == false
  end
end
