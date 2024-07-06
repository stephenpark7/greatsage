module AuthHelper
  include Exceptions

  def authenticate_user
    access_token = Token.new(AccessToken, nil, get_token(AccessToken))

    payload = access_token.decode
    raise AuthenticationError, 'Invalid token' if payload.nil?

    @user = User.find_by_id(payload['user_id']) # secure_find_by_id(User, payload['user_id'])
    raise AuthenticationError, 'Invalid token' if @user.nil?
  rescue ResponseError => e
    render(json: { type: 'error', message: e.message }, status: :unauthorized)
  end

  def get_token(model)
    case model.to_s
    when 'AccessToken'
      retrieve_access_token_from_authorization_header
    when 'RefreshToken'
      retrieve_refresh_token_from_cookie
    end
  end

  private

  # def secure_find_by_id(model, id)
  #   # TODO: this code is not working proper.
  #   # also we should look at start time at begining of the method (of refresh route, or login route)
  #   # and then compare it with the end time to see if the time difference is less than x ms
  #   # if it is less than x ms, then we should sleep for x ms - time difference
  #   # this will make the timing attack harder

  #   start_time = Time.now

  #   # Attempt to find the record
  #   record = model.find_by_id(id)

  #   # Introduce a fixed delay to mitigate timing attacks
  #   minimum_response_time = 100 # in milliseconds
  #   elapsed_time = ((Time.now - start_time) * 1000).to_i
  #   sleep_time = minimum_response_time - elapsed_time

  #   sleep(sleep_time / 1000) if sleep_time.positive?

  #   record
  # end

  def retrieve_access_token_from_authorization_header
    authorization_header = request.headers['Authorization']
    raise AuthenticationError, 'Missing token' if authorization_header.nil?
    raise AuthenticationError, 'Invalid token' unless authorization_header.match?(/^Bearer /)

    access_token = authorization_header.split(' ')[1]
    raise AuthenticationError, 'Invalid token' if access_token.nil?

    access_token
  end

  def retrieve_refresh_token_from_cookie
    cookies[:refresh_token]
  end
end
