class ChangeMagnetToBeTextInTorrents < ActiveRecord::Migration[6.0]
  def change
    change_column :torrents, :magnet, :text
  end
end
