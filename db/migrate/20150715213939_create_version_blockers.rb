class CreateVersionBlockers < ActiveRecord::Migration
  def change
    create_table :version_blockers do |t|
      t.integer :version_id
      t.integer :gemblocker_id

      t.timestamps null: false
    end
  end
end
