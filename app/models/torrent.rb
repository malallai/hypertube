class Torrent < ApplicationRecord
  belongs_to :movie

  def progress
    return 0 if hashid.nil?
    content = $qbt_client.contents hashid
    return 0 if content.nil?
    content.each do |file|
      return file['progress'].to_f * 100 if file['name']['.mp4'] || file['name']['.mkv']
    end
  end

  def ready
    return true if stored && progress > 15
    false
  end
end
