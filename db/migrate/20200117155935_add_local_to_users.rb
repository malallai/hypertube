class AddLocalToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :local, :string
  end
end
