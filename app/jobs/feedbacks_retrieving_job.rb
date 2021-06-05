class FeedbacksRetrievingJob < ApplicationJob
  queue_as :medium

  def perform(options)
    file_token = SecureRandom.base58(50)
    file_name = "feedbacks_#{file_token}.txt"
    file_location = File.expand_path(file_name, Rails.root.join("storage"))
    
    file = File.open(file_location, "w")

    Feedback.where(options[:conditions]).find_in_batches(batch_size: 5000) do |feedbacks|
      file.write(feedbacks.as_json.join("\n"))
    end

    file.close

    BiMemberMailer.feedbacks_report_email(options[:email], file_location).deliver_now
  end
end