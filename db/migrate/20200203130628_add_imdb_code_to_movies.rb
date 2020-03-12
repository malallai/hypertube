class AddImdbCodeToMovies < ActiveRecord::Migration[6.0]
  def change
    add_column :movies, :imdb_code, :string
    add_index :movies, :imdb_code, unique: true
  end
end
