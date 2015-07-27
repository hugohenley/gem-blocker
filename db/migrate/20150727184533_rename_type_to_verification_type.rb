class RenameTypeToVerificationType < ActiveRecord::Migration
  def change
    rename_column :gemblockers, :type, :verification_type
  end
end
