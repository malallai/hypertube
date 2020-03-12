class CreateMovies < ActiveRecord::Migration[6.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :source
      t.string :source_id
      t.string :size
      t.boolean :stored

      t.timestamps
    end
  end
end
