class RemoveSourceidFromMovies < ActiveRecord::Migration[6.0]
  def change

    remove_column :movies, :sourceid, :string
  end
end
