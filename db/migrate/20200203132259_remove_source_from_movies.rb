class RemoveSourceFromMovies < ActiveRecord::Migration[6.0]
  def change

    remove_column :movies, :source, :string
  end
end
