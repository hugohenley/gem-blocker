class CreateRubyGems < ActiveRecord::Migration
  def change
    create_table :ruby_gems do |t|
      t.string :name
      t.string :description
      t.string :current_version
      t.string :authors
      t.string :info

      t.timestamps null: false
    end
  end
end
