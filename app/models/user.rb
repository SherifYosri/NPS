class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  include Devise::JWT::RevocationStrategies::Allowlist

  self.primary_key = 'uuid'
  attribute :uuid, MySQLBinUUID::Type.new

  #-Callbacks-----
    before_validation do
      self.uuid = ApplicationRecord.generate_uuid
    end
  #-----

  devise :database_authenticatable, :registerable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  #-Validations-----
    validates :name, :uuid, presence: true
  #-----
end