class AddDiffToUsedGem < ActiveRecord::Migration
  def change
    add_column :used_gems, :diff, :string
  end
end
