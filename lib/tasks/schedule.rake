namespace :meh do
  desc "Schedule recordings for all podcasts"
  task schedule: :environment do
    Podcast.schedule_recording
  end
end