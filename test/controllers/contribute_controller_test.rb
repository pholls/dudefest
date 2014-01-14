require 'test_helper'

class ContributeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
