class Gemblocker < ActiveRecord::Base
  belongs_to :rubygem
  belongs_to :version

  has_many :versionblockers

  def list
  end

end
