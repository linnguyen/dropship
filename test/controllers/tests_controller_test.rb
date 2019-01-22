require 'test_helper'

class TestsControllerTest < ActionDispatch::IntegrationTest
  test "should get tes" do
    get tests_tes_url
    assert_response :success
  end

end
