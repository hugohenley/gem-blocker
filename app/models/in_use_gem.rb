class InUseGem < ActiveRecord::Base
  belongs_to :commit
end
