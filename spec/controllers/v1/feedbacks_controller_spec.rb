require 'rails_helper'
require 'devise/jwt/test_helpers'

describe V1::FeedbacksController, type: :controller do
  describe "GET #index" do
    before(:example) do
      @bi_member = BiMember.first
      add_auth_headers(@bi_member)
    end

    context 'success' do
      it "should respond with 200" do
        get :index, params: {
          touchpoint: "realtor_feedback",
          object_class: "realtor",
          respondent_class: "seller"
        }

        expect(response).to have_http_status(:ok)
        expect(data).to be_an_instance_of(String)
      end

      it "should respond with 200 even if optional params not sent" do
        get :index, params: {
          touchpoint: "realtor_feedback"
        }

        expect(response).to have_http_status(:ok)
      end

      it "should enqueue a job to retrieve feedbacks records" do
        enqueued_jobs_before_calling_endpoint = ActiveJob::Base.queue_adapter.enqueued_jobs.size
        
        get :index, params: {
          touchpoint: "realtor_feedback"
        }

        enqueued_jobs_after_calling_endpoint = ActiveJob::Base.queue_adapter.enqueued_jobs.size
        enqueued_jobs = ActiveJob::Base.queue_adapter.enqueued_jobs.map{ |j| j[:job] }

        expect(enqueued_jobs_after_calling_endpoint - enqueued_jobs_before_calling_endpoint).to eq(1)
        expect(enqueued_jobs).to include(FeedbacksRetrievingJob)
      end
    end

    context 'failure' do
      it "responds with 400 status code if a required param not sent" do
        get :index, params: {
          object_class: "realtor",
          respondent_class: "seller"
        }

        expect(response).to have_http_status(:bad_request)
        expect(errors).to be_an_instance_of(Array)
        expect(errors.first[:detail]).to eq("touchpoint")
      end

      it "responds with 401 if access token isn't valid" do
        request.headers["Authorization"] = "I'm a dummy string"
        get :index, params: { 
          touchpoint: "realtor_feedback",
          object_class: "realtor",
          respondent_class: "seller"
        }
        
        expect(response).to have_http_status(:unauthorized)
      end

      it "responds with 403 if user isn't a BI team member" do
        add_auth_headers(Seller.first)

        get :index, params: { 
          touchpoint: "realtor_feedback",
          object_class: "realtor",
          respondent_class: "seller"
        }
        
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "POST #create" do
    deal = Deal.first
    create_params = {
      respondent_id: deal.seller.id,
      object_id: deal.realtor.id,
      score: 8,
      touchpoint: "realtor_feedback",
      respondent_class: "seller",
      object_class: "realtor",
      feedback_token: deal.feedback_token
    }

    context 'success' do
      it "should respond with 200" do
        post :create, params: create_params
        
        expect(response).to have_http_status(:ok)
        expect(data).to be_an_instance_of(Hash)
      end

      it "should create a feedback and respond with its data" do
        feedbacks_count_before_calling_endpoint = Feedback.count
        post :create, params: create_params
        
        feedbacks_count_after_calling_endpoint = Feedback.count

        expect(data[:type]).to eq("feedbacks")
        expect(feedbacks_count_after_calling_endpoint - feedbacks_count_before_calling_endpoint).to eq(1)
      end

      it "should overwrite the feedback if it's already created" do
        feedback = FactoryBot.create(:feedback, realtor: deal.realtor, seller: deal.seller)

        feedbacks_count_before_calling_endpoint = Feedback.count
        post :create, params: create_params
        feedbacks_count_after_calling_endpoint = Feedback.count

        expect(feedbacks_count_after_calling_endpoint).to eq(feedbacks_count_before_calling_endpoint)
        expect(feedback.reload.score).to eq(create_params[:score])
      end
    end

    context 'failure' do
      it "should respond with 400 status code if there are missing parameters" do
        invalid_create_params = create_params
        invalid_create_params.delete :score
        post :create, params: invalid_create_params

        expect(response).to have_http_status(:bad_request)
      end

      it "should respond with 404 status code if seller is not found" do
        invalid_create_params = create_params.clone
        invalid_create_params[:respondent_id] += "dummy"
        
        post :create, params: invalid_create_params
        expect(response).to have_http_status(:not_found)
      end

      it "should respond with 404 status code if realtor is not found" do
        invalid_create_params = create_params.clone
        invalid_create_params[:object_id] += "dummy"
        
        post :create, params: invalid_create_params
        expect(response).to have_http_status(:not_found)
      end

      it "should respond with 422 status code if feedback_token is invalid" do
        invalid_create_params = create_params.clone
        invalid_create_params[:feedback_token] += "dummy"
        
        post :create, params: invalid_create_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should respond with 422 status code if there is no previous deal between seller and realtor" do
        invalid_create_params = create_params.clone
        invalid_create_params[:respondent_id] = Seller.last.id
        invalid_create_params[:object_id] = Realtor.last.id
        
        post :create, params: invalid_create_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should respond with 422 status code if sent score is not between 0 and 10" do
        invalid_create_params = create_params.clone
        invalid_create_params[:score] = 100
        
        post :create, params: invalid_create_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(errors.first[:source][:pointer]).to eq("/data/attributes/score")
      end
    end
  end
end
