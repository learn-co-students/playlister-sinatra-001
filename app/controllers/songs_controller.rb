class SongsController < ApplicationController
  register Sinatra::Flash

  get '/songs' do
    @songs = Song.all

    erb :'songs/index'
  end

  get '/songs/new' do
    erb :'songs/new'
  end

  get "/songs/:slug" do
    load_song

    erb :'songs/show'
  end

  # {"Artist Name"=>"Person with a Face", "Name"=>"That One with the Guitar", "genres"=>["1"]}
  post '/songs' do
    @song = Song.create(:name => params["Name"])
    @song.artist = Artist.find_or_create_by(:name => params["Artist Name"])

    @song.genre_ids = params[:genres]

    @song.save

    erb :"songs/show", locals: {message: "Successfully created song."}
  end

  get '/songs/:slug/edit' do
    load_song

    erb :"songs/edit"
  end

  patch '/songs/:slug' do
    load_song

    @song.name = params["Name"]
    @song.artist = Artist.find_or_create_by(:name => params["Artist Name"])

    @genres = Genre.find(params[:genres])
    
    @song.song_genres.clear
    @genres.each do |genre|
      song_genre = SongGenre.new(:song => @song, :genre => genre)
      song_genre.save
    end

    @song.save
    flash[:message] = "Song successfully updated."

    redirect "/songs/#{@song.slug}"
  end

  private
    def load_song
      @song = Song.find_by_slug(params[:slug])
    end
end
