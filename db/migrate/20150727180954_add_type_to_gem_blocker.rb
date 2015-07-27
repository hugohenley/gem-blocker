class AddTypeToGemBlocker < ActiveRecord::Migration
  def change
    add_column :gemblockers, :type, :string
  end
end
