class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.integer :used_gem
      t.string :type
      t.string :locked_versions

      t.timestamps null: false
    end
  end
end
