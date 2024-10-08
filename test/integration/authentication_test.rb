require 'test_helper'

class AuthenticationTest < ActionDispatch::IntegrationTest
  # Would be nice to understand how to fix this, using duplicated fixtures for the moment...

  # self.fixture_paths << Rails.root.join( "/../fixtures")
  fixtures :all

  def setup
    Tolk::ApplicationController.authenticator = proc do
      authenticate_or_request_with_http_basic {|user_name, password| user_name == 'lifo' && password == 'pass' }
    end
  end

  def teardown
    Tolk::ApplicationController.authenticator = nil
  end

  test "failed authentication" do
    get '/tolk'
    assert_response 401
  end

  test "successful authentication" do
    env = Hash.new
    env['HTTP_AUTHORIZATION'] = encode_credentials('lifo', 'pass')
    get '/tolk', params: nil, env: env
    assert_response :success
  end

  protected

  def encode_credentials(username, password)
    "Basic #{Base64.encode64("#{username}:#{password}")}"
  end
end
