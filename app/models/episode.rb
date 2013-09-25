class Episode < ActiveRecord::Base
  belongs_to :podcast

  validates_presence_of :podcast

  scope :scheduled, -> { where("scheduled_at > ?", Time.now) }

  def schedule
    scheduled_at = Time.zone.now
    # next day_of_week
    scheduled_at += ((self.podcast.day_of_week - scheduled_at.wday) % 7).days
    scheduled_at = scheduled_at.change(hour: self.podcast.start_at.hour, min: self.podcast.start_at.min, second: 0)
    if scheduled_at < Time.now
      scheduled_at += 7.days
    end
    self.scheduled_at = scheduled_at
    self.save
  end

  def self.schedule_for_podcasts(podcasts)
    podcasts.each do |podcast|
      unless self.scheduled.where(podcast: podcast).first
        episode = self.new(podcast: podcast)
        episode.schedule
      end
    end
  end
end