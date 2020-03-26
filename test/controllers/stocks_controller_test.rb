require 'test_helper'

class StocksControllerTest < ActionDispatch::IntegrationTest

  setup do
    sign_in users(:test_user)
  end

  test "should get index" do
    get stocks_path
    assert_response :success
  end

  test "should get show" do
    get stock_path(stocks(:aapl))
    assert_response :success
  end

  test "should create stock with valid symbol" do
    IEX::Api::Client.any_instance.stubs(:company).returns(
      OpenStruct.new(company_name: "adadsgew", exchange: "gahrrh", sector: "ahhe", website: "ahehex/ahe/")
    )
    assert_difference('users(:test_user).stocks.count', 1) do
      post stocks_path, params: { stock: { symbol: "NVDA" } }
    end
    assert_redirected_to root_path
    assert_equal flash[:success], "NVDA Submitted"
  end

  test "should not create stock with invalid symbol" do
    Stock.stubs(:validate_symbol).returns(false)
    assert_difference('users(:test_user).stocks.count', 0) do
      post stocks_path, params: { stock: { symbol: "AGAEGDED" } }
    end
    assert_redirected_to root_path
    assert_equal flash[:alert], "Unable to find stock with symbol: AGAEGDED"
  end

  test "should not create stock that is already being tracked by the user" do
    assert_difference('users(:test_user).stocks.count', 0) do
      post stocks_path, params: { stock: { symbol: "AAPL" } }
    end
    assert_redirected_to root_path
    assert_equal flash[:info], "You are already tracking this symbol"
  end
end
