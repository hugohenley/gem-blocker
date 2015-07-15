class CreateGemblockers < ActiveRecord::Migration
  def change
    create_table :gemblockers do |t|
      t.integer :rubygem_id
      t.integer :version_id

      t.timestamps null: false
    end
  end
end
