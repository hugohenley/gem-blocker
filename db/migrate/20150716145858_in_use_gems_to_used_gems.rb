class InUseGemsToUsedGems < ActiveRecord::Migration
  def change
    rename_table :in_use_gems, :used_gems
  end
end
