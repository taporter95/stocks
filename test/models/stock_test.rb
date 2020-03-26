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

  test 'will return list of stocks and create any that do not exist yet' do 
    IEX::Api::Client.any_instance.stubs(:get).returns([{"symbol"=>"MFA"}, 
      {"symbol"=>"F"}, {"symbol"=>"GE"}, {"symbol"=>"BAC"}, 
      {"symbol"=>"CCL"}, {"symbol"=>"AAL"}, {"symbol"=>"AMD"}, 
      {"symbol"=>"OXY"}, {"symbol"=>"TLRY"}, {"symbol"=>"MSFT"}])
    IEX::Api::Client.any_instance.stubs(:company).returns(
      OpenStruct.new(company_name: "adadsgew", exchange: "gahrrh", sector: "ahhe", website: "ahehex/ahe/")
    )
    assert_equal 2, Stock.all.size
    stocks = Stock.get_list("mostactive")
    assert_equal 10, stocks.size
    assert_equal 11, Stock.all.size
  end

  test 'will not return list for invalid list type' do
    stocks = Stock.get_list("mostinactive")
    assert_nil stocks
  end
end
