class MoviesController < ApplicationController
  include MoviesHelper
  include YtsApi
  include PopTimeApi
  include OstApi
  before_action :authenticate_user!
  before_action :set_movie, only: [:show]
  require 'qbt_client'

  def show
    imdb_code = params[:imdb_code]
    if @movie.nil?
      Tmdb::Api.language :en
      @result = get_details(imdb_code)
      title = @result[:details]['title']
      @movie = Movie.create({:imdb_code => imdb_code})
      yts = yts_find(title, imdb_code)
      ptime = ptime_find(title, imdb_code)
	  srts = Array.new 
	  tmp_srts = subtitles_serialize(search_srt(@movie.imdb_code))
                    .select {|srt| srt[:lang]['French'] || srt[:lang]['English']}
	  tmp_srts.group_by { |srt| srt[:lang] }.each { |srt| srts << srt[1][0] }
      unless yts.nil?
        yts['torrents'].each do |torrent|
          magnet = "magnet:?xt=urn:btih:#{torrent['hash']}&dn=#{URI::encode(title)}&tr=udp://open.demonii.com:1337/announce&tr=udp://tracker.openbittorrent.com:80"
          @movie.torrents.create({:source => 'yts', :magnet => magnet, :size => torrent['size_bytes'], :quality => torrent['quality']})
        end
      end
      unless ptime.nil?
        ptime['torrents']['en'].each do |torrent|
          @movie.torrents.create({:source => 'ptime', :magnet => torrent[1]['url'], :size => torrent[1]['size'], :quality => torrent[0]})
        end
      end
      unless srts.nil?
        srts.each do |srt|
          @movie.subtitles.create({:lang => srt[:lang], :download_uri => srt[:download], :stored_path => '/downloads/ost/' + SecureRandom.uuid + '.srt'})
        end
      end
      unless @movie.subtitles.nil?
        @movie.subtitles.each do |sub|
          sub.download
        end
      end
    end
    Tmdb::Api.language session[:locale]
    @sorted_torrents = sort_torrents @movie.torrents
    @result = get_details(imdb_code)
  end

  def refresh_part
    respond_to do |format|
      torrent = Torrent.find_by_id(params[:tid])
      format.js { render "refresh_part", :locals => {torrent: torrent, title: get_details(torrent.movie[:imdb_code])[:details]['title']} }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      if params[:imdb_code].nil?
        @movie = Movie.find(params[:id])
      else
        @movie = Movie.find_by_imdb_code(params[:imdb_code])
      end
    end

  def sort_torrents torrents
    yts = Array.new
    ptime = Array.new
    torrents.each do |torrent|
      yts << torrent if torrent[:source] == 'yts'
      ptime << torrent if torrent[:source] == 'ptime'
    end
    {yts: yts, ptime: ptime}
  end
end
