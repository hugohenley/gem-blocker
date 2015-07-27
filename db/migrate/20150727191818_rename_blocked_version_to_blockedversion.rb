class RenameBlockedVersionToBlockedversion < ActiveRecord::Migration
  def change
    rename_table :blocked_versions, :blockedversions
  end
end
