module V1
  class FeedbacksController < ApplicationController
    before_action :load_respondent, :load_realtor, :check_feedback_token, only: :create
    skip_before_action :authenticate_user!, only: :create

    def create
      permitted_params = validate_create_params!
      
      feedback = if feedback_already_exists?
        feedback_updater.update(permitted_params)
      else
        feedback_creator.create(permitted_params.except(:respondent_id, :object_id))
      end

      render json: feedback, status: :ok
    end

    def index
      authorize! :read, Feedback
      
      permitted_params = validate_index_params!
      permitted_params.slice!(:touchpoint, :respondent_class, :object_class)
      
      feedbacks_retriever.schedule_retrieving_job(conditions: permitted_params, user_email: current_user.email)
      
      success_message = "A job is scheduled to retrieve the requested data. An email will be sent to you once it's ready"

      render json: { data: success_message }, status: :ok
    end

    private

    def load_respondent
      @respondent = Seller.find_by_uuid!(params[:respondent_id])
    end
    
    def load_realtor
      @realtor = Realtor.find_by_uuid!(params[:object_id])
    end

    def check_feedback_token
      token = params[:feedback_token]
      deal = Deal.find_by_feedback_token(token)
      if deal.blank? || deal.respondent_id != params[:respondent_id] || deal.object_id != params[:object_id]
        error_message =  "You have to deal with this realtor before giving a feedback"
        raise Errors::UnprocessableEntity.new([error_message])
      end
    end

    def load_feedback
      @feedback ||= Feedback.where(seller: @respondent, realtor: @realtor, touchpoint: params[:touchpoint]).first
    end

    def feedback_already_exists?
      load_feedback.present?
    end

    def validate_create_params!
      create_params = %w(score touchpoint respondent_class object_class respondent_id object_id)
      validate_params_presence!(create_params)

      params.permit(create_params)
    end

    def validate_index_params!
      required_index_params = ["touchpoint"]
      validate_params_presence!(required_index_params)
      index_params = required_index_params.append("respondent_class", "object_class")
      
      permitted_params = params.permit(index_params)
    end

    def feedback_creator
      require 'feedbacks/creator'
      @feedback_creator ||= ::Feedbacks::Creator.new(respondent: @respondent, object: @realtor)
    end

    def feedback_updater
      require 'feedbacks/updater'
      @feedback_updater ||= ::Feedbacks::Updater.new(load_feedback)
    end

    def feedbacks_retriever
      require 'feedbacks/retriever'
      @feedback_retriever ||= ::Feedbacks::Retriever.new
    end
  end
end