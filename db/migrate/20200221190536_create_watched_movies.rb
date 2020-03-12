class CreateWatchedMovies < ActiveRecord::Migration[6.0]
  def change
    create_table :watched_movies do |t|
      t.references :user, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true
      t.boolean :watched, default: false

      t.timestamps
    end
  end
end
