class TorrentWorker
  include Sidekiq::Worker

  def perform(t_id, downloaded)
    torrent = Torrent.find t_id
    file = get_file downloaded
    if file.nil?
      TorrentWorker.perform_in(2.seconds, t_id, downloaded)
      return
    else
      torrent.stored_name = file
      torrent.stored = true
      torrent.save
    end
  end

  private

  def get_file torrent
    files = $qbt_client.contents(torrent['hash'])
    unless files.nil?
      files.each do |file|
        return file['name'] if file['name']['.mp4'] || file['name']['.mkv']
      end
    end
    nil
  end

end
