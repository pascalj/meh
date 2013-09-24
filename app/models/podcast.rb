class Podcast < ActiveRecord::Base

  belongs_to :stream

  validates_presence_of :name, :stream
  validates :length, numericality: { greater_than: 0 }
end
