class Deal < ApplicationRecord
  #-Associations-----
    belongs_to :seller, foreign_key: "respondent_id"
    belongs_to :realtor, foreign_key: "object_id"

    # Decode UUID of Sellers and Realtors before inserting into the db
    attribute :respondent_id, MySQLBinUUID::Type.new
    attribute :object_id, MySQLBinUUID::Type.new
  #-----

  #-Validations-----
    validates :feedback_token, presence: true
  #-----
end
