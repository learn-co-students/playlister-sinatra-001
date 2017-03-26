class Song < ActiveRecord::Base

  belongs_to :artist
  has_many :song_genres
  has_many :genres, through: :song_genres

  def slug
    self.name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

  def self.find_by_slug(slug)
    this_song = nil
    Song.all.each do |song|
      if song.slug == slug
        this_song = song
      end
    end
    this_song
  end

end
