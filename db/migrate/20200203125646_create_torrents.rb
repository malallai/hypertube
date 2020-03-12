class CreateTorrents < ActiveRecord::Migration[6.0]
  def change
    create_table :torrents do |t|
      t.references :movie, :null => false, :foreign_key => true
      t.string :source
      t.string :magnet
      t.integer :size
      t.boolean :stored, :default => false
      t.string :stored_name

      t.timestamps
    end
  end
end
