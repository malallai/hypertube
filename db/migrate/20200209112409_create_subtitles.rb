class CreateSubtitles < ActiveRecord::Migration[6.0]
  def change
    create_table :subtitles do |t|
      t.references :movie, null: false, foreign_key: true
      t.string :lang
      t.string :stored_path
      t.boolean :stored

      t.timestamps
    end
  end
end
