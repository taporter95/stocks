require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "will return true if the user is tracking a stock" do 
      assert users(:test_user).tracking_symbol?("AAPL")
  end

  test "will return false if the user is not tracking a stock" do
    refute users(:test_user).tracking_symbol?("GE")
  end
end
