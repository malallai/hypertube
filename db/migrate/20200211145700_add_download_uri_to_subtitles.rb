class AddDownloadUriToSubtitles < ActiveRecord::Migration[6.0]
  def change
    add_column :subtitles, :download_uri, :string
  end
end
