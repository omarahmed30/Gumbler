class AddingColumTable < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :author_name, :string
    add_column :users, :nick_name, :string
  end
end
