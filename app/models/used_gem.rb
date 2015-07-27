class UsedGem < ActiveRecord::Base
  belongs_to :commit

  def self.to_hash!(all_gems)
    hash = {}
    all_gems.each do |x|
      hash["#{x.name}"] = x.version
    end
    hash
  end

end
