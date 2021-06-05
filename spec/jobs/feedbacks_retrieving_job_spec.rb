require 'rails_helper'

describe FeedbacksRetrievingJob, type: :job do
  include ActiveJob::TestHelper

  options = {
    email: BiMember.first.email,
    conditions: { touchpoint: "realtor_feedback" }
  }
  subject(:job) { described_class.perform_later(options) }

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
  
  it 'queues the job' do
    expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'is in medium queue' do
    expect(FeedbacksRetrievingJob.new.queue_name).to eq('medium')
  end

end