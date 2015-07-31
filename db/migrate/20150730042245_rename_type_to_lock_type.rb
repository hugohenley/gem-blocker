class RenameTypeToLockType < ActiveRecord::Migration
  def change
    rename_column :statuses, :type, :lock_type
  end
end
