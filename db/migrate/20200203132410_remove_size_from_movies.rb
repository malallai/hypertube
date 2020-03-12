class RemoveSizeFromMovies < ActiveRecord::Migration[6.0]
  def change

    remove_column :movies, :size, :string
  end
end
