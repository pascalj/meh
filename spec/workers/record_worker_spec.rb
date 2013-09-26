require 'spec_helper'

describe RecordWorker do
  describe "#perform" do
    it "copies the file to the destination" do
      episode = FactoryGirl.create(:episode, :scheduled)
      tmp = '/tmp/foo'
      worker = RecordWorker.new
      worker.should_receive(:start_record).and_return(tmp)
      destination = File.join(Settings[:recording][:target_directory], episode.filename)
      FileUtils.should_receive(:mv).with(tmp + '.mp3', destination)
      worker.perform(episode.id)
    end

    it "creates the destination directory if not exists" do
      episode = FactoryGirl.create(:episode, :scheduled)
      tmp = '/tmp/foo'
      worker = RecordWorker.new
      worker.should_receive(:start_record).and_return(tmp)
      destination = File.join(Settings[:recording][:target_directory], episode.filename)
      FileUtils.should_receive(:mkdir_p).with(Settings[:recording][:target_directory])
      FileUtils.should_receive(:mv).with(tmp + '.mp3', destination)
      worker.perform(episode.id)
    end

    it "sets the finshed_at" do
      episode = FactoryGirl.create(:episode, :scheduled)
      tmp = '/tmp/foo'
      worker = RecordWorker.new
      worker.stub(:start_record).and_return("")
      worker.stub(:system)
      FileUtils.stub(:mkdir_p)
      FileUtils.stub(:mv)
      worker.perform(episode.id)
      episode.reload
      episode.finished_at.should_not be_nil
    end
  end

  describe "#start_record" do
    it "throws an error if streamripper is not installed" do
      episode = FactoryGirl.create(:episode, :scheduled)
      worker = RecordWorker.new
      worker.should_receive(:system).with('which streamripper > /dev/null 2>&1').and_return(false)
      expect{
        worker.start_record(episode)
      }.to raise_error
    end

    it "returns the output path" do
      episode = FactoryGirl.create(:episode, :scheduled)
      worker = RecordWorker.new
      worker.stub(:system).and_return(true)
      worker.start_record(episode).should_not == ""
    end
  end
end