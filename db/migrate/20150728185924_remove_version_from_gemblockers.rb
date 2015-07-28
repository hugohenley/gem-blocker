class RemoveVersionFromGemblockers < ActiveRecord::Migration
  def change
    remove_column :gemblockers, :version
  end
end
