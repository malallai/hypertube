class AddHashidToTorrents < ActiveRecord::Migration[6.0]
  def change
    add_column :torrents, :hashid, :text
  end
end
