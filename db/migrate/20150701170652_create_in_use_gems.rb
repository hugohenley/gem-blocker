class CreateInUseGems < ActiveRecord::Migration
  def change
    create_table :in_use_gems do |t|
      t.string :name
      t.string :version
      t.string :description
      t.integer :commit_id

      t.timestamps null: false
    end
  end
end
