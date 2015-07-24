class AddServerToProject < ActiveRecord::Migration
  def change
    add_column :projects, :server, :string
  end
end
