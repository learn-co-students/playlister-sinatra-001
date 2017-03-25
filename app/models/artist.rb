class Artist < ActiveRecord::Base

  has_many :genres, through: :songs
  has_many :songs  

  def slug
    self.name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

  def self.find_by_slug(slug)
    this_artist = nil
    Artist.all.each do |artist|
      if artist.slug == slug
        this_artist = artist
      end
    end
    this_artist
  end

end
