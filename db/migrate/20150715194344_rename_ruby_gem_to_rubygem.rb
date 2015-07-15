class RenameRubyGemToRubygem < ActiveRecord::Migration
  def change
    rename_table :ruby_gems, :rubygems
  end
end
