# frozen_string_literal: true

module Api
  module V1
    class CsrfTokenController < ApplicationController
      skip_before_action :authenticate_user
      # protect_from_forgery with: :exception

      def show
        render json: { csrf_token: session[:_csrf_token] }
      end
    end
  end
end
