# frozen_string_literal: true

class TodoList < ApplicationRecord
  belongs_to :user
end
