class RenameUsedGemtoUsedGemIdOnStatus < ActiveRecord::Migration
  def change
    rename_column :statuses, :used_gem, :used_gem_id
  end
end
