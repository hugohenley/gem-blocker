class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :hash
      t.string :title
      t.string :author_name
      t.string :author_email

      t.timestamps null: false
    end
  end
end
