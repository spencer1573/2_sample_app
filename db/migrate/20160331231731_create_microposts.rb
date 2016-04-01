class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    #QUESTION: i have no idea what all of this means
    add_index :microposts, [:user_id, :created_at]
  end
end
