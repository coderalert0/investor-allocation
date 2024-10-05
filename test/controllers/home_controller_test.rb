require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @valid_params = {
      allocation_amount: "100",
      investor_amounts: [
        { name: "Investor A", requested_amount: "150", average_amount: "100" },
        { name: "Investor B", requested_amount: "50", average_amount: "25" }
      ]
    }
  end

  test "should get new" do
    # Test that the 'new' action renders the new template
    get root_path
    assert_response :success
    assert_template :new
  end

  test "should sanitize params and call AllocationProration in create" do
    post create_path, params: @valid_params

    # Assert that the correct template is rendered and the instance variable @results is set
    assert_response :success
    assert_template :new
    assert_equal({ 'Investor A' =>80.0, 'Investor B' => 20.0 }, assigns(:results))
  end

  test "should sanitize params correctly" do
    # Trigger the create action with string parameters
    post create_path, params: @valid_params

    # Assert that the params were sanitized and converted to floats
    assert assigns(:results).values.all? { |num| num.is_a? Float }
  end
end
