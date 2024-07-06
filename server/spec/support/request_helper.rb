# frozen_string_literal: true

module RequestHelper
  def verify_response(response, type, message, status = :ok)
    expect(response).to have_http_status(status)
    body = response.parsed_body
    expect(body['type']).to eq(type)
    expect(body['message']).to eq(message.to_s)
  end

  def register_user(email, password)
    post('/api/v1/auth/register', params: { email:, password: })
  end

  def login_user(email, password)
    post('/api/v1/auth/login', params: { email:, password: })
  end

  def logout_user(token)
    post('/api/v1/auth/logout', headers: { 'Authorization': "Bearer #{token}" })
  end

  def measure_request_time(user_status)
    start_time = Time.now
    yield
    elapsed_time = ((Time.now - start_time) * 1000.0) * 100.0
    puts "hit /refresh endpoint with #{user_status} user: #{elapsed_time.to_i}ms"
    elapsed_time
  end
end
