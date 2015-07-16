class Commit < ActiveRecord::Base
  belongs_to :project
  has_many :used_gems

end
