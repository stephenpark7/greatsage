# frozen_string_literal: true

RSpec.shared_examples 'a token that can be initialized' do |model|
  include Exceptions

  let(:token) { described_class.new(model, user, 'not_a_real_token') }

  context 'when token instance is initialized' do
    it 'sets the model' do
      expect(token.model).to eq(model)
    end

    it 'sets the user' do
      expect(token.user).to eq(user)
    end

    it 'sets the exp' do
      expect(token.exp).to be_truthy
    end

    it 'does not set the jti' do
      expect(token.jti).to be_nil
    end

    it 'sets the token' do
      expect(token.token).to be_truthy
    end

    it 'can be encoded' do
      expect(token.encode).to be_truthy
    end

    context 'when token is invalid' do
      it 'cannot be decoded' do
        expect(token.decode).to be_nil
      end

      it 'cannot be revoked' do
        expect { token.revoke }.to raise_error(Exceptions::ValidationError)
      end
    end

    context 'when token is valid' do
      it 'can be decoded' do
        token.encode
        expect(token.decode).to be_truthy
      end

      it 'can be revoked' do
        token.encode
        token.revoke
        expect(RevokedToken.find_by_jti(token.jti)).to be_truthy
      end
    end
  end
end

RSpec.shared_examples 'a token that can be created' do |model|
  let(:token) { described_class.create(model, user) }

  context 'when token instance is created' do
    it 'sets the model' do
      expect(token.model).to eq(model)
    end

    it 'sets the user' do
      expect(token.user).to eq(user)
    end

    it 'sets the jti' do
      expect(token.jti).to be_truthy
    end

    it 'sets the exp' do
      expect(token.exp).to be_truthy
    end

    it 'sets the token' do
      expect(token.token).to be_truthy
    end

    it 'can be decoded' do
      expect(token.decode).to be_truthy
    end

    it 'can be revoked' do
      token.revoke
      expect(RevokedToken.find_by_jti(token.jti)).to be_truthy
    end
  end

  let(:instance) { model.find_by_jti(token.jti) }

  if model::CREATE_INSTANCE
    context 'when CREATE_INSTANCE is true' do
      context 'when active record model instance is created' do
        it 'has the correct jti' do
          expect(instance.jti).to eq(token.jti)
        end

        it 'has the correct user_id' do
          expect(instance.user_id).to eq(user.id)
        end

        it 'has the correct expires_at' do
          expect(instance.expires_at).to eq(Time.at(token.exp))
        end
      end
    end
  else
    context 'when CREATE_INSTANCE is false' do
      context 'when active record model instance is not created' do
        it 'is nil' do
          expect(instance).to be_nil
        end
      end
    end
  end
end
