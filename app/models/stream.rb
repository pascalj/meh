class Stream < ActiveRecord::Base
  extend FriendlyId

  validates_presence_of :name
  validates_presence_of :url
  validates_format_of :url, with: URI.regexp

  friendly_id :name
end
