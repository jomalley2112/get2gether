class AddNameFieldsToPeople < ActiveRecord::Migration
  def change
    add_column :people, :first_name, :string
    add_column :people, :last_name, :string
    add_index :people, :first_name
    add_index :people, :last_name
  end
end
