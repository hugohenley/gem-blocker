class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :ssh_url_to_repo
      t.string :http_url_to_repo

      t.timestamps null: false
    end
  end
end
