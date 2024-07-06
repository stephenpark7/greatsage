# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::CsrfTokenController, type: :request do
  describe 'GET #show' do
    before do
      get '/api/v1/csrf_token'
    end

    it 'returns a 200 status code' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns a CSRF token' do
      csrf_token = response.parsed_body['csrf_token']
      session_token = session[:_csrf_token]
      expect(csrf_token).to eq(session_token)
    end
  end
end
