class RemoveTitleFromMovies < ActiveRecord::Migration[6.0]
  def change

    remove_column :movies, :title, :string
  end
end
