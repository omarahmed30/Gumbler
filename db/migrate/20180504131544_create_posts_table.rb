class CreatePostsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :post_content
      t.integer :user_id
      t.string :image
      t.datetime :created_at
      t.datetime :updated_at
      t.string :author_name
    end
  end
end
