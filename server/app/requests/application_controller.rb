# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Exceptions

  rescue_from ResponseError, with: :render_error_response

  # skip_before_action :verify_authenticity_token
  before_action :authenticate_user

  def render_error_response(message)
    render(json: { type: 'error', message: }, status: :ok)
  end
end
