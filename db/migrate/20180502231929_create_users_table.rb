class CreateUsersTable < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :username
      t.string :password
      t.datetime :birthday
      t.datetime :created_at
      t.datetime :updated_at
    end

  end
end
