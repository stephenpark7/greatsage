# frozen_string_literal: true

module Exceptions
  class ResponseError < StandardError; end
  class ValidationError < ResponseError; end
  class AuthenticationError < ResponseError; end
  class DecodeError < AuthenticationError; end
  class ExpiredToken < AuthenticationError; end
end
