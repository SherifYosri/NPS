class Seller < User
  has_many :feedbacks, foreign_key: "respondent_id"
end