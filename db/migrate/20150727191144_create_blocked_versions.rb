class CreateBlockedVersions < ActiveRecord::Migration
  def change
    create_table :blocked_versions do |t|
      t.string :number
      t.integer :gemblocker_id

      t.timestamps null: false
    end
  end
end
