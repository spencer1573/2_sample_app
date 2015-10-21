# this is modeling well explained
# https://gist.github.com/pyk/8569812
class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, default: false
  end
end