class Movie < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :torrents, dependent: :destroy
  has_many :subtitles, dependent: :destroy
  has_many :watched_movie, dependent: :destroy
end
