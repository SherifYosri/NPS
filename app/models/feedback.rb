class Feedback < ApplicationRecord
  #-Associations-----
    belongs_to :seller, foreign_key: "respondent_id"
    belongs_to :realtor, foreign_key: "object_id"

    # Decode UUID of Sellers and Realtors before inserting into the db
    attribute :respondent_id, MySQLBinUUID::Type.new
    attribute :object_id, MySQLBinUUID::Type.new
  #-----

  #-Validations-----
    validates :score, :touchpoint, :respondent_class, :object_class, presence: true
    validates :score, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
    validates :respondent_id, uniqueness: { scope: [:object_id, :touchpoint] }
  #-----
end
