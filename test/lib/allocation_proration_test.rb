require 'test_helper'

class AllocationProrationTest < ActiveSupport::TestCase
  test "should allocate investments based on historical average" do
    input = {
      allocation_amount: 100,
      investor_amounts: [
        { name: "Investor A", requested_amount: 150, average_amount: 100 },
        { name: "Investor B", requested_amount: 50, average_amount: 25 }
      ]
    }

    expected_allocation = {
      "Investor A" => 80.0,
      "Investor B" => 20.0
    }

    result = AllocationProration.allocate_investments(input)
    assert_equal expected_allocation, result
  end

  test "should allocate entire amount when allocation is equal to the requested amount" do
    input = {
      allocation_amount: 100,
      investor_amounts: [
        { name: "Investor A", requested_amount: 50, average_amount: 50 },
        { name: "Investor B", requested_amount: 50, average_amount: 50 }
      ]
    }

    expected_allocation = {
      "Investor A" => 50.0,
      "Investor B" => 50.0
    }

    result = AllocationProration.allocate_investments(input)
    assert_equal expected_allocation, result
  end

  test "should prorate when allocation is less than requested amount" do
    input = {
      allocation_amount: 75,
      investor_amounts: [
        { name: "Investor A", requested_amount: 100, average_amount: 100 },
        { name: "Investor B", requested_amount: 50, average_amount: 25 }
      ]
    }

    expected_allocation = {
      "Investor A" => 60.0,
      "Investor B" => 15.0
    }

    result = AllocationProration.allocate_investments(input)
    assert_equal expected_allocation, result
  end

  test "should not allocate more than requested" do
    input = {
      allocation_amount: 200,
      investor_amounts: [
        { name: "Investor A", requested_amount: 50, average_amount: 100 },
        { name: "Investor B", requested_amount: 50, average_amount: 25 }
      ]
    }

    expected_allocation = {
      "Investor A" => 50.0,
      "Investor B" => 50.0
    }

    result = AllocationProration.allocate_investments(input)
    assert_equal expected_allocation, result
  end

  test "should redistribute unused allocation" do
    input = {
      allocation_amount: 100,
      investor_amounts: [
        { name: "Investor A", requested_amount: 50, average_amount: 50 },
        { name: "Investor B", requested_amount: 25, average_amount: 25 }
      ]
    }

    expected_allocation = {
      "Investor A" => 50,
      "Investor B" => 25
    }

    result = AllocationProration.allocate_investments(input)
    assert_equal expected_allocation, result
  end
end
