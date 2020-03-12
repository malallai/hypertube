class ChangeMovieSourceId < ActiveRecord::Migration[6.0]
  def self.up
    rename_column :movies, :source_id, :sourceid
  end
end
