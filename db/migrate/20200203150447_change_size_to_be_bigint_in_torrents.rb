class ChangeSizeToBeBigintInTorrents < ActiveRecord::Migration[6.0]
  def change
    change_column :torrents, :size, :bigint
  end
end
