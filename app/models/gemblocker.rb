class Gemblocker < ActiveRecord::Base
  has_many :blockedversions
  accepts_nested_attributes_for :blockedversions, reject_if: :all_blank, allow_destroy: true

  scope :with_version, -> (version) { joins(:blockedversions).where('blockedversions.number = ?', version)}

  scope :by_type, -> (type) { where('verification_type = ?', type)}

  validates_presence_of :gem, :verification_type
  validate :allowed_types

  ALLOWED_TYPES = ["Required", "Allow If Present", "Deny"]

  VERIFIED_TYPES = ["Required", "Allow If Present", "Deny", "Not Present"]

  def allowed_types
    unless ALLOWED_TYPES.include? verification_type
      errors.add(:verification_type, 'This type is not allowed.')
    end
  end

  def self.hash_of type
    required = []
    Gemblocker.by_type(type).each do |gem|
      hash = {}
      versions = gem.blockedversions.map {|x| x.number }
      hash["#{gem.gem}"] = versions
      required << hash
    end
    required
  end

end
