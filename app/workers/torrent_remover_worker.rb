class TorrentRemoverWorker
  include Sidekiq::Worker

  def perform
    torrents = Torrent.all
    if !torrents.nil? & !torrents.empty?
      torrents.each do |torrent|
        if torrent.stored
          file = Rails.public_path.join("#{ENV['STORED_PATH'].slice(1, ENV['STORED_PATH'].length)}/#{torrent.stored_name}").to_s
          if !File.exist? file
            reset_torrent torrent
          else
            if DateTime.now > torrent.updated_at + 1.month
              File.delete file
              reset_torrent torrent
            end
          end
        end
      end
    end
  end

  private

  def reset_torrent torrent
    torrent.stored = false
    torrent.stored_name = nil
    torrent.hashid = nil
    torrent.save
  end

end