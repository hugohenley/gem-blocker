class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :hash_id
      t.string :title
      t.string :author_name
      t.string :author_email
      t.datetime :commit_created_at

      t.timestamps null: false
    end
  end
end
