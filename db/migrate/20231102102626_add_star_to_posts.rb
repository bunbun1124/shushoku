class AddStarToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :username, :string
    add_column :posts, :overall, :integer
    add_column :posts, :level, :integer
  end
end
