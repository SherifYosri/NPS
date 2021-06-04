class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.generate_uuid
    SecureRandom.uuid
  end
end
