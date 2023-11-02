class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :name
      t.string :graduation
      t.string :title
      t.date :date
      t.text :about

      t.timestamps
    end
  end
end
