require 'rack-flash'

class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :session_secret, "my_application_secret"
  enable :sessions
  set :views, Proc.new { File.join(root, "../views/") }

  use Rack::Flash 

  LibraryParser.new.call

  get '/' do
    erb :index
  end

  get '/songs' do
    erb :songs
  end

  get '/artists' do
    erb :artists
  end

  get '/genres' do
    erb :genres
  end

  get '/songs/new' do
    erb :new_song
  end

  post '/songs/new' do

    new_song = Song.new

    artist = params["artist"]

    if Artist.find_by_name(artist) == nil
      new_artist = Artist.new
      new_artist.name = artist
      new_song.artist = new_artist
    else
      new_song.artist = Artist.find_by_name(artist)
    end

    new_song.name = params["Name"]

    new_song.save

    params["genres"].each do |genre|
      new_song.song_genres.create(genre: Genre.find(genre))
    end

    new_song.save
    flash[:message] = "Successfully created song."

    redirect "/songs/#{new_song.slug}"
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb :show_song
  end

  get '/artists/:slug' do
    @artist = Artist.find_by_slug(params[:slug])
    erb :show_artist
  end

  get '/genres/:slug' do
    @genre = Genre.find_by_slug(params[:slug])
    erb :show_genre
  end

  get '/songs/:slug/edit' do
    @song = Song.find_by_slug(params[:slug])
    erb :edit_song
  end

  post '/songs/:slug/edit' do
    @song = Song.find_by_slug(params[:slug])

    artist = params["artist"]
    name = params["Name"]


    if @song.name != name
      @song.name = name
    end

    if @song.artist.name != artist && Artist.find_by_name(artist) == nil
      new_artist = Artist.new
      new_artist.name = artist
      @song.artist = new_artist
    elsif @song.artist.name != artist && Artist.find_by_name(artist) != nil
      @song.artist = Artist.find_by_name(artist)
    end

    @song.save

    flash[:message] = "Successfully updated song."

    redirect "/songs/#{@song.slug}"
  end



end