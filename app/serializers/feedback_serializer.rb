class FeedbackSerializer < ActiveModel::Serializer
  attributes :score, :touchpoint, :respondent_class, :object_class
end