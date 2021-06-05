module Feedbacks
  class Creator
    def initialize(respondent:, object:)
      @respondent, @realtor = respondent, object
    end

    def create(feedback_attributes)
      feedback_attributes.merge!(get_respondent_and_object_classes)
      feedback = @respondent.feedbacks.build(feedback_attributes)
      feedback.realtor = @realtor
      feedback.save!
      
      feedback
    end

    private
    # Auto correct respondent and object classes in case they were sent wrong
    def get_respondent_and_object_classes
      classes = {}
      classes[:respondent_class] = "seller" if @respondent.is_a? Seller
      classes[:object_class] = "realtor" if @object.is_a? Realtor

      classes
    end
  end
end