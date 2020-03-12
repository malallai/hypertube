class StreamsController < ApplicationController
  include MoviesHelper
  before_action :authenticate_user!
  before_action :set_torrent, only: [:index]
  before_action :check_ready, only: [:index]

  def index
    @movie_file = @torrent[:stored_name]
    @movie = @torrent.movie
    @srts = @movie.subtitles
    @comments = @movie.comments

    file = Rails.public_path.join("#{ENV['STORED_PATH'].slice(1, ENV['STORED_PATH'].length)}/#{@movie_file}").to_s
    redirect_to "/movies/#{@torrent.movie[:imdb_code]}", alert: t('stream.notfound') unless File.exist? file || !file['.mp4'] || !file['.mkv']

    current_user.watched_movie.create({:user => current_user, :movie => @movie, :watched => true}) unless current_user.watched_movie.exists? :movie => @movie.id
    @result = get_details(@movie[:imdb_code])
    @movie.updated_at = Time.now
    @movie.save
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_torrent
    @torrent = Torrent.find(params[:torrent_id])
  end

  def check_ready
    redirect_to "/movies/#{@torrent.movie[:imdb_code]}", alert: t('stream.notready', progress: @torrent.progress.round(2)) unless @torrent.ready
  end

end
