class TorrentsController < ApplicationController
  before_action :set_torrent, only: [:download]

  def download
    info = get_by_magnet(@torrent[:magnet])
    if !info.nil?
      @torrent.hashid = info['hash']
      @torrent.stored = true
      @torrent.save
    else
      $qbt_client.download(@torrent[:magnet])
      downloaded = get_by_magnet(@torrent[:magnet])
      $qbt_client.seq(downloaded['hash'])
      @torrent.hashid = downloaded['hash']
      @torrent.save
      TorrentWorker.perform_in(2.seconds, @torrent[:id], downloaded)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_torrent
      @torrent = Torrent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def torrent_params
      params.require(:torrent).permit(:movie_id, :source, :magnet, :size, :stored, :stored_name)
    end

  def get_by_magnet magnet
    torrents = $qbt_client.torrent_list
    return nil if torrents.nil? || torrents.empty?
    search = magnet.scan(/magnet:\?xt=urn:([a-zA-Z0-9]*):([a-zA-Z0-9]*)/).last.last
    torrents.each do |torrent|
      magnet_uri = torrent['magnet_uri'].scan(/magnet:\?xt=urn:([a-zA-Z0-9]*):([a-zA-Z0-9]*)/).last.last
      return torrent if search.downcase.include?(magnet_uri.downcase)
    end
    nil
  end
end
