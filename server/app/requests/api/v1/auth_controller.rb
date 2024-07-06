# frozen_string_literal: true

module Api
  module V1
    class AuthController < ApplicationController
      include Exceptions
      include AuthHelper

      skip_before_action :authenticate_user, only: %i[register login refresh]

      def register
        User.create!(email: user_params[:email], password: user_params[:password])
        send_response('message', 'User created successfully')
      end

      def login
        user = authenticate_email_and_password(user_params[:email], user_params[:password])
        access_token = Token.create(AccessToken, user)
        refresh_token = Token.create(RefreshToken, user)
        cookies[:refresh_token] = refresh_token.httponly_cookie
        send_response('message', access_token.token)
      end

      def logout
        access_token = Token.new(AccessToken, nil, get_token(AccessToken))
        refresh_token = Token.new(RefreshToken, nil, get_token(RefreshToken))
        access_token.decode
        refresh_token.decode
        access_token.revoke
        refresh_token.revoke
        cookies.delete(:refresh_token)
        send_response('message', 'Logged out successfully')
      end

      def refresh
        @start_time = Time.now
        refresh_token = Token.new(RefreshToken, nil, get_token(RefreshToken))
        payload = refresh_token.decode
        user_id = payload['user_id']
        access_token = Token.create(AccessToken, User.find_by_id(user_id))
        uniform_sleep
        send_response('message', access_token.token)
      rescue StandardError
        uniform_sleep
        raise DecodeError, 'Invalid token'
      end

      private

      def uniform_sleep
        raise 'Invalid start time' if @start_time.nil?

        minimum_response_time = 2.0
        elapsed_time = ((Time.now - @start_time) * 1000.0)
        sleep_time = [minimum_response_time - elapsed_time, 0].max / 1000.0
        sleep(sleep_time)
      end

      def authenticate_email_and_password(email, password)
        user = User.authenticate_by(email:, password:)
        raise AuthenticationError, 'Invalid email or password' if user.nil?

        user
      end

      def send_response(type, message)
        render(json: { type:, message: })
      end

      def user_params
        params.except(:user).permit(:email, :password)
      end
    end
  end
end
