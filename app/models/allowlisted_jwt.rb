class AllowlistedJwt < ApplicationRecord
  belongs_to :user, primary_key: "uuid"

  # Decode UUID of user before inserting into the db
  attribute :user_id, MySQLBinUUID::Type.new
end