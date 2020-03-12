class Subtitle < ApplicationRecord
  belongs_to :movie
  require 'webvtt'

  def download
    unless self.stored
      f = Rails.public_path.join('downloads/ost').to_s
      Dir.mkdir f unless Dir.exists? f
      path = Rails.public_path.join("#{self.stored_path.slice(1, self.stored_path.length)}.gz").to_s
      open(path, 'wb') do |file|
        file << open(self.download_uri).read
      end
      new_path = path.slice(0, path.length - 3)
      `gunzip #{path}`
      begin
        WebVTT.convert_from_srt(new_path)
        self.stored_path = self.stored_path.gsub(".srt", ".vtt")
      end
      self.stored = true
      self.save
    end
  end
end
