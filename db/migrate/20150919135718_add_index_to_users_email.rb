class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
    #         table    column  unique: true enforces the uniqueness
    add_index :users, :email, unique: true
  end
end
