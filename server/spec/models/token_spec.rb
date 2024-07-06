# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples_for_tokens'

TOKEN_TYPES = Token::TOKEN_TYPES

RSpec.describe Token, type: :model do
  let(:user) { create(:user) }

  describe '#initialize' do
    TOKEN_TYPES.each do |token_type|
      context "when model is #{token_type}" do
        it_behaves_like 'a token that can be initialized', token_type
      end
    end
  end

  describe '#create' do
    TOKEN_TYPES.each do |token_type|
      context "when model is #{token_type}" do
        it_behaves_like 'a token that can be created', token_type
      end
    end
  end
end
