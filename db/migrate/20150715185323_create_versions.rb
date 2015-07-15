class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.string :number
      t.string :summary
      t.string :description

      t.timestamps null: false
    end
  end
end
