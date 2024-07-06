# frozen_string_literal: true

module ModelHelper
  include Exceptions

  def assert_exception_is_thrown(exception, message, &block)
    expect(&block).to raise_error(exception, message.to_s)
  end
end
