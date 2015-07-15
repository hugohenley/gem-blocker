class AddRubyGemIdToVersion < ActiveRecord::Migration
  def change
    add_column :versions, :rubygem_id, :integer
  end
end
