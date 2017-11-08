require 'test_helper'

class CodeControllerTest < ActionDispatch::IntegrationTest
  test "should get execute" do
    get code_execute_url
    assert_response :success
  end

end
