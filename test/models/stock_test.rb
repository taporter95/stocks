require 'test_helper'

class StockTest < ActiveSupport::TestCase

  test "will create a stock object if the symbol is valid" do
    new_stock = users(:test_user).stocks.new
    new_stock.assign_attributes(symbol: "F")
    assert new_stock.save
  end

  test "will return false for an invalid symbol" do
    new_stock = users(:test_user).stocks.new
    new_stock.assign_attributes(symbol: "QDGWDGED")
    refute new_stock.save
    assert new_stock.errors.full_messages.include?("Symbol does not exist")
  end

end
