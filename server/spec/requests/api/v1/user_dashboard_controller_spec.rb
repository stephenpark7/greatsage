# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UserDashboardController, type: :request do
  include RequestHelper

  describe 'GET /api/v1/user_dashboard/get_todo_lists' do
    context 'when user is not authenticated' do
      it 'returns an error message' do
        get('/api/v1/user_dashboard/todo_lists', headers: { 'Authorization': 'Bearer 123' })
        verify_response(response, 'error', 'Invalid token', :unauthorized)
      end
    end

    context 'when user is authenticated' do
      let(:user) { build(:user) }

      before do
        register_user(user.email, user.password)
        login_user(user.email, user.password)
        cookies['refresh_token'] = response.cookies['refresh_token']
        User.last.todo_lists.create(title: 'Test')
      end

      it 'is successful' do
        expect(response).to have_http_status(:success)
      end

      it "returns the user's todo lists" do
        get('/api/v1/user_dashboard/todo_lists',
            headers: { 'Authorization': "Bearer #{response.parsed_body['message']}" })
        expect(response.parsed_body.first['title']).to eq('Test')
      end
    end
  end
end
