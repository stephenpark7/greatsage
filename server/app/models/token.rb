# frozen_string_literal: true

class Token
  include Exceptions
  include AuthHelper

  attr_accessor :model, :user, :exp, :jti, :token

  SECRET_KEY = ENV['SECRET_KEY_BASE']
  SIGNING_ALGORITHM = 'HS256'
  TOKEN_TYPES = [AccessToken, RefreshToken].freeze

  # Class methods

  def self.create(model, user)
    new(model, user, nil).tap(&:encode)
  end

  def self.revoked?(token)
    return nil if token?['jti'].nil?

    RevokedToken.exists?(jti: token['jti'])
  end

  def self.expired?(token)
    return nil if token?['exp'].nil?

    Time.now.to_i > token['exp']
  end

  # Instance methods

  def initialize(model, user, token)
    @model = model
    validate(:model)

    @user = user
    @exp = Time.now.to_i + @model::EXPIRY_TIME
    @token = token
  end

  def encode
    generate_and_encode_token
    handle_model_instance
    @token
  end

  def decode
    validate_args(:model, :token)

    payload = JWT.decode(token, SECRET_KEY, true, { algorithm: SIGNING_ALGORITHM })&.first
    assign_instance_variables(payload)

    payload
  rescue JWT::DecodeError
    nil
  end

  def generate_payload
    {
      'model' => @model,
      'jti' => @jti || generate_jti,
      'user_id' => @user.id,
      'exp' => @exp
    }
  end

  def create_active_record_model_instances
    @model.create!(
      jti: @jti,
      user_id: @user.id,
      expires_at: Time.at(@exp)
    )
  end

  def assign_instance_variables(jwt)
    @user = User.find_by_id(jwt['user_id'])
    @exp = jwt['exp'] if jwt['exp'].present?
    @jti = jwt['jti'] if jwt['jti'].present?
    @token = jwt['token'] if jwt['token'].present?
    validate_args
  end

  def httponly_cookie
    validate_args

    {
      value: @token,
      expires: Time.at(@exp),
      domain: ENV['DOMAIN'],
      httponly: true,
      secure: Rails.env.production?
    }
  end

  def revoke
    validate_args

    RevokedToken.create!(
      jti: @jti,
      user_id: @user.id,
      expires_at: Time.at(@exp)
    )
  end

  private

  def generate_and_encode_token
    validate_all_args_except(:jti, :token)
    payload = generate_payload
    @token = JWT.encode(payload, SECRET_KEY, SIGNING_ALGORITHM)
    @jti = payload['jti']
  end

  def handle_model_instance
    model = @model.find_by(jti: @jti)
    return unless @model::CREATE_INSTANCE

    if model.present?
      @model.update!(jti: @jti, expires_at: Time.at(@exp))
    else
      create_active_record_model_instances
    end
  end

  def generate_jti
    raise ValidationError, 'Jti already exists' if @jti.present?

    SecureRandom.uuid
  end

  VALIDATIONS = {
    model: ->(obj) { obj.model.present? && TOKEN_TYPES.include?(obj.model) },
    user: ->(obj) { obj.user.present? && obj.user.is_a?(User) },
    exp: ->(obj) { obj.exp.present? && obj.exp.is_a?(Integer) },
    token: ->(obj) { obj.token.present? && obj.token.is_a?(String) },
    jti: ->(obj) { obj.jti.present? && obj.jti.is_a?(String) }
  }.freeze

  def validate(attribute)
    raise ValidationError, "Invalid #{attribute}" unless VALIDATIONS[attribute].call(self)
  end

  def validate_args(*args)
    return VALIDATIONS.each_key { |attribute| validate(attribute) } if args.empty?

    args.each { |attribute| validate(attribute) }
  end

  def validate_all_args_except(*args)
    (VALIDATIONS.keys - args).each { |attribute| validate(attribute) }
  end
end
