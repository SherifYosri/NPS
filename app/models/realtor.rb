class Realtor < User
  has_many :feedbacks, foreign_key: "object_id"
end