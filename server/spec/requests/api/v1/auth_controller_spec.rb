# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :request do
  include RequestHelper

  describe 'POST /api/v1/auth/register' do
    let(:user) { build(:user) }

    context 'when registering with incomplete or invalid data' do
      it 'returns an error message when email is missing' do
        register_user(nil, user.password)
        verify_response(response, 'error', I18n.t('exceptions.validation_errors.email.blank'))
      end

      it 'returns an error message when password is missing' do
        register_user(user.email, nil)
        verify_response(response, 'error', I18n.t('exceptions.validation_errors.password.blank'))
      end

      it 'returns an error message when both email and password are missing' do
        register_user(nil, nil)
        verify_response(response, 'error', I18n.t('exceptions.validation_errors.email_and_password.blank'))
      end

      it 'returns an error message when email is invalid' do
        register_user('invalid@email', user.password)
        verify_response(response, 'error', I18n.t('exceptions.validation_errors.email.invalid'))
      end

      it 'returns an error when password is invalid' do
        register_user(user.email, 'short')
        verify_response(response, 'error', I18n.t('exceptions.validation_errors.password.too_short'))
      end

      it 'returns an error when email is already taken' do
        duplicate_user = create(:user)
        user.email = duplicate_user.email
        register_user(duplicate_user.email, duplicate_user.password)
        verify_response(response, 'error', I18n.t('exceptions.validation_errors.email.taken'))
      end
    end

    context 'when registering with valid data' do
      it 'creates a new user' do
        register_user(user.email, user.password)
        verify_response(response, 'message', I18n.t('responses.fulfilled.register'))
      end
    end
  end

  describe 'POST /api/v1/auth/login' do
    let(:user) { build(:user) }

    context 'when logging in with incomplete or invalid data' do
      it 'returns an error message when email is missing' do
        login_user(nil, user.password)
        verify_response(response, 'error', I18n.t('responses.rejected.invalid_credentials'))
      end

      it 'returns an error message when password is missing' do
        login_user(user.email, nil)
        verify_response(response, 'error', I18n.t('responses.rejected.invalid_credentials'))
      end

      it 'returns an error message when both email and password are missing' do
        login_user(nil, nil)
        verify_response(response, 'error', I18n.t('responses.rejected.invalid_credentials'))
      end

      it 'returns an error message when email is invalid' do
        login_user('invalid', user.password)
        verify_response(response, 'error', I18n.t('responses.rejected.invalid_credentials'))
      end

      it 'returns an error message when password is invalid' do
        login_user(user.email, 'invalid')
        verify_response(response, 'error', I18n.t('responses.rejected.invalid_credentials'))
      end

      it 'returns an error message when both email and password are invalid' do
        login_user('invalid', 'invalid')
        verify_response(response, 'error', I18n.t('responses.rejected.invalid_credentials'))
      end

      # when token is expired
      # when token is revoked
    end

    context 'when logging in with valid data' do
      before do
        user = create(:user)
        login_user(user.email, user.password)
      end

      it 'returns a jwt token' do
        token = response.parsed_body['message']
        expect(token).to be_present
      end

      it 'does not set an access token cookie' do
        expect(response.cookies['access_token']).to be_nil
      end

      it 'sets a refresh token cookie' do
        expect(response.cookies['refresh_token']).to be_present
      end
    end
  end

  describe 'POST /api/v1/auth/logout' do
    context 'when logging out with valid data' do
      before do
        user = create(:user)
        login_user(user.email, user.password)

        cookies['refresh_token'] = response.cookies['refresh_token']

        logout_user(response.parsed_body['message'])
      end

      it 'returns a success message' do
        verify_response(response, 'message', I18n.t('responses.fulfilled.logout'))
      end

      it 'clears the access token cookie' do
        expect(response.cookies['access_token']).to be_nil
      end

      it 'clears the refresh token cookie' do
        expect(response.cookies['refresh_token']).to be_nil
      end

      it 'revokes tokens' do
        expect(RevokedToken.count).to eq(2)
      end
    end

    context 'when logging out with no access token' do
      it 'returns an error message' do
        logout_user(nil)
        verify_response(response, 'error', 'Invalid token', :unauthorized)
      end
    end

    context 'when logging out with an expired token' do
      before do
        user = create(:user)
        login_user(user.email, user.password)

        refresh_token_cookie = response.cookies['refresh_token']

        access_token = Token.new(AccessToken, user, response.parsed_body['message'])
        refresh_token = Token.new(RefreshToken, user, refresh_token_cookie)

        access_token.decode
        refresh_token.decode

        access_token.exp = (Time.now - 7.day).to_i
        refresh_token.exp = (Time.now - 7.day).to_i

        access_token.encode
        refresh_token.encode

        cookies['refresh_token'] = refresh_token.token
        logout_user(access_token.token)
      end

      it 'returns an error message' do
        verify_response(response, 'error', 'Invalid token', :unauthorized)
      end
    end

    elapsed_times = []

    # Define a shared context for timing attack tests
    shared_context 'timing attack' do |user_status, token_modification_proc = nil|
      before do
        login_user(user.email, user.password)
        refresh_token_cookie = response.cookies['refresh_token']
        refresh_token = Token.new(RefreshToken, user, refresh_token_cookie)
        token_modification_proc&.call(refresh_token)

        cookies['refresh_token'] = refresh_token.token

        elapsed_time = measure_request_time(user_status) do
          post('/api/v1/auth/refresh')
        end

        elapsed_times << elapsed_time
      end

      after(:context) do # rubocop:disable RSpec/BeforeAfterAll
        puts "Elapsed times: #{elapsed_times}"
      end
    end

    # Using the shared context in tests
    context 'when attempting a timing attack with refresh route' do
      let(:user) { create(:user) }

      context 'when the user is valid' do
        include_context 'timing attack', 'valid'
        it 'returns a jwt token' do
          response_token = response.parsed_body['message']
          access_token = Token.new(AccessToken, nil, response_token)
          access_token.decode
          expect(access_token.user).to eq(user)
        end
      end

      context 'when the user is invalid' do
        include_context 'timing attack', 'invalid', lambda { |token|
          token.decode
          diff_user = token.user.dup
          token.user = diff_user
          diff_user.destroy
          token.encode
        }
        it 'returns an error message for invalid token' do
          verify_response(response, 'error', 'Invalid token', :ok)
        end
      end

      context 'when the token has only the header valid' do
        include_context 'timing attack', 'valid token', lambda { |token|
          token.token = token.token.split('.').first
        }
        it 'returns an error message' do
          verify_response(response, 'error', 'Invalid token', :ok)
        end
      end

      context 'when the token has valid header and payload but invalid signature' do
        include_context 'timing attack', 'invalid token', lambda { |token|
          token.token = token.token.split('.')[0..1].join('.')
        }
        it 'returns an error message' do
          verify_response(response, 'error', 'Invalid token', :ok)
        end
      end

      context 'when elapsed time is measured' do
        it 'returns a uniform elapsed time' do
          elapsed_times.combination(2).each do |time1, time2|
            expect(time1).to be_within(100).of(time2)
          end
        end
      end
    end
  end
end
