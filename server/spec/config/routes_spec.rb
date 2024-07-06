require 'rails_helper'

RSpec.describe 'Routes', type: :routing do
  it 'routes /api/v1/auth/register to the register action' do
    expect(post: '/api/v1/auth/register').to route_to('api/v1/auth#register')
  end

  it 'routes /api/v1/auth/login to the login action' do
    expect(post: '/api/v1/auth/login').to route_to('api/v1/auth#login')
  end

  it 'routes /api/v1/auth/logout to the logout action' do
    expect(post: '/api/v1/auth/logout').to route_to('api/v1/auth#logout')
  end

  it 'routes /api/v1/auth/refresh to the refresh action' do
    expect(post: '/api/v1/auth/refresh').to route_to('api/v1/auth#refresh')
  end

  it 'routes /api/v1/user_dashboard/todo_lists to the todo_lists action' do
    expect(get: '/api/v1/user_dashboard/todo_lists').to route_to('api/v1/user_dashboard#todo_lists')
  end

  it 'routes /api/v1/csrf_token to the show action' do
    expect(get: '/api/v1/csrf_token').to route_to('api/v1/csrf_token#show')
  end
end
