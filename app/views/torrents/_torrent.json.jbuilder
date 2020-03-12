json.extract! torrent, :id, :movie_id, :source, :magnet, :size, :stored, :stored_name, :created_at, :updated_at
json.url torrent_url(torrent, format: :json)
