class CreateGemblockers < ActiveRecord::Migration
  def change
    create_table :gemblockers do |t|
      t.string :gem
      t.string :version

      t.timestamps null: false
    end
  end
end
