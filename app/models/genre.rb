class Genre < ActiveRecord::Base

  has_many :artists, through: :songs
  has_many :songs, through: :song_genres
  has_many :song_genres

  def slug
    self.name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

  def self.find_by_slug(slug)
    this_genre = nil
    Genre.all.each do |genre|
      if genre.slug == slug
        this_genre = genre
      end
    end
    this_genre
  end

end