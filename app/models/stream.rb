class Stream < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :url
  validates_format_of :url, with: URI.regexp
end
