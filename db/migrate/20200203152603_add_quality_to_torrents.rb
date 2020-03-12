class AddQualityToTorrents < ActiveRecord::Migration[6.0]
  def change
    add_column :torrents, :quality, :string
  end
end
