class Commit < ActiveRecord::Base
  belongs_to :project
  has_many :used_gems, :dependent => :destroy

  def self.already_imported?(commit)
    Commit.where(hash_id: commit["id"]).any?
  end

end
