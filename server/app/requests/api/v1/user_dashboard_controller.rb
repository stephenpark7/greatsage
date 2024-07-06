# frozen_string_literal: true

module Api
  module V1
    class UserDashboardController < ApplicationController
      include AuthHelper
      include Exceptions

      before_action :authenticate_user

      def todo_lists
        render(json: current_user&.todo_lists)
      end
    end
  end
end
