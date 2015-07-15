class RenameVersionBlockerToVersionblocker < ActiveRecord::Migration
  def change
    rename_table :version_blockers, :versionblockers
  end
end
