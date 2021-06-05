module Feedbacks
  class Retriever
    def schedule_retrieving_job(conditions:, user_email:)
      options = { email: user_email, conditions: conditions }
      FeedbacksRetrievingJob.perform_later(options)
    end
  end
end