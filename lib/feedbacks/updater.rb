module Feedbacks
  class Updater
    def initialize(feedback)
      @feedback = feedback
    end

    def update(feedback_attributes)
      @feedback.update!(score: feedback_attributes[:score])

      @feedback
    end
  end
end