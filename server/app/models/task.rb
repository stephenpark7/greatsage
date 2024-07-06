# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :todo_list
end
