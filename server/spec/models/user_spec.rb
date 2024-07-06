# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  include Exceptions
  include ModelHelper

  let(:user) { build(:user) }

  context 'when registering with valid data' do
    it 'creates a new user' do
      described_class.create!(email: user.email, password: user.password)
      expect(described_class.count).to eq(1)
    end
  end

  context 'when registering with missing data' do
    it 'raises an error when email is missing' do
      assert_exception_is_thrown(Exceptions::ValidationError,
                                 I18n.t('exceptions.validation_errors.email.blank')) do
        described_class.create!(email: nil, password: user.password)
      end
    end

    it 'raises an error when password is missing' do
      assert_exception_is_thrown(Exceptions::ValidationError,
                                 I18n.t('exceptions.validation_errors.password.blank')) do
        described_class.create!(email: user.email, password: nil)
      end
    end

    it 'raises an error when both email and password are missing' do
      assert_exception_is_thrown(Exceptions::ValidationError,
                                 I18n.t('exceptions.validation_errors.email_and_password.blank')) do
        described_class.create!(email: nil, password: nil)
      end
    end
  end

  context 'when registering with invalid data' do
    it 'raises an error when email is invalid' do
      assert_exception_is_thrown(Exceptions::ValidationError,
                                 I18n.t('exceptions.validation_errors.email.invalid')) do
        described_class.create!(email: 'invalid_email', password: user.password)
      end
    end

    it 'raises an error when password is too short' do
      assert_exception_is_thrown(Exceptions::ValidationError,
                                 I18n.t('exceptions.validation_errors.password.too_short')) do
        described_class.create!(email: user.email, password: 'short')
      end
    end

    it 'raises an error when password is too long' do
      assert_exception_is_thrown(Exceptions::ValidationError,
                                 I18n.t('exceptions.validation_errors.password.too_long')) do
        described_class.create!(email: user.email, password: 'longpassword' * 10)
      end
    end
  end

  context 'when registering with duplicate data' do
    it 'raises an error when email is already taken' do
      assert_exception_is_thrown(Exceptions::ValidationError,
                                 I18n.t('exceptions.validation_errors.email.taken')) do
        2.times { described_class.create!(email: user.email, password: user.password) }
      end
    end
  end
end
