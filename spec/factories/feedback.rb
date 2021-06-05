FactoryBot.define do
  factory :feedback do
    seller { nil }
    realtor { nil }
    score { Faker::Number.between(from: 0, to: 10) }
    touchpoint { "realtor_feedback" }
    respondent_class { "seller" }
    object_class { "realtor" }
  end
end