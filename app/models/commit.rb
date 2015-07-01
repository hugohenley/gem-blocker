class Commit < ActiveRecord::Base
  belongs_to :project
  has_many :in_use_gems

end
