require 'spec_helper'

describe Episode do

  it "requires a stream" do
    expect(Episode.new).to_not be_valid
  end

  it "is valid with a stream" do
    expect(FactoryGirl.build(:episode, :scheduled)).to be_valid
  end

  describe "scope scheduled" do

    it "finds episodes that are scheduled" do
      @scheduled = FactoryGirl.create_list(:episode, 4, :scheduled)
      expect(Episode.scheduled).to eq(@scheduled)
    end

    it "ignores episodes that were scheduled in the past" do
      @scheduled = FactoryGirl.create_list(:episode, 4, :scheduled)
      @scheduled_yesterday = FactoryGirl.create_list(:episode, 5, :scheduled_yesterday)
      expect(Episode.scheduled.count).to eq(@scheduled.length)
    end
  end

  describe "#schedule" do

    context "not scheduled" do

      before :each do
        expect(RecordWorker).to receive(:perform_at).and_return("JOB_ID")
        allow(Sidekiq::Status).to receive(:queued?).and_return(false)
      end

      it "saved the record" do
        episode = Episode.new(podcast: FactoryGirl.create(:podcast))
        expect{
          episode.schedule
        }.to change(Episode, :count).by(1)
      end

      it "sets the scheduled day_of_week correctly" do
        podcast = FactoryGirl.create(:podcast)
        episode = Episode.new(podcast: podcast)
        episode.schedule
        expect(episode.scheduled_at.wday).to eq(podcast.day_of_week)
      end

      it "sets the time correctly" do
        podcast = FactoryGirl.create(:podcast)
        episode = Episode.new(podcast: podcast)
        episode.schedule
        expect(episode.scheduled_at.hour).to eq(podcast.start_at.hour)
        expect(episode.scheduled_at.min).to eq(podcast.start_at.min)
      end

      it "sets scheduled_at to future dates" do
        podcast = FactoryGirl.create(:podcast)
        episode = Episode.new(podcast: podcast)
        episode.schedule
        expect(episode.scheduled_at > Time.zone.now).to eq(true)
      end

      it "saves the job_id" do
        podcast = FactoryGirl.create(:podcast)
        episode = Episode.new(podcast: podcast)
        episode.schedule
        expect(episode.job_id).to eq("JOB_ID")
      end
    end

    context "already scheduled" do

      it "does not schedule again if a job is already scheduled" do
        expect(Sidekiq::Status).to receive(:queued?).and_return(true)

        podcast = FactoryGirl.create(:podcast)
        episode = Episode.new(podcast: podcast)
        episode.schedule
        expect(RecordWorker).to_not receive(:perform_at)
      end
    end
  end

  describe "#schedule_for_podcasts" do

    it "creates episodes for each podcast" do
      allow(RecordWorker).to receive(:perform_at).and_return("JOB_ID")
      podcasts = FactoryGirl.create_list(:podcast, 5, :today)

      expect{
        Episode.schedule_for_podcasts(podcasts)
      }.to change(Episode, :count).by(podcasts.length)
    end
  end

  describe "#filename" do
    it 'generates a filename' do
      episode = FactoryGirl.create(:episode, :scheduled)
      generated_filename = "#{episode.podcast.save_name}-#{episode.scheduled_at.strftime('%Y-%m-%d')}.mp3"
      expect(episode.filename).to eq(generated_filename)
    end
  end

  describe "#duration" do
    it "formats the time in H:M:S" do
      start_time = 16.hours.ago
      end_time = start_time + 5.hours + 16.minutes + 11.seconds
      podcast = FactoryGirl.build(:episode, scheduled_at: start_time, finished_at: end_time)
      expect(podcast.duration).to eq('05:16:11')
    end
  end
end
