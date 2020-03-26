require 'test_helper'

class MovingAverageTEst < ActiveSupport::TestCase
    test "will return simple moving averages" do
        test_data = [24, 21, 19, 23, 34, 29, 27, 25, 18, 16]
        #5 day moving average over 5 total days
        results = MovingAverage.get_simple_moving_averages(test_data, 5, 5)
        assert_equal results, [24.2, 25.2, 26.4, 27.6, 26.6]
    end

    test "will return nil if the sample size is not large enough" do 
        test_data = [24, 21, 19, 23, 34, 29]
        results = MovingAverage.get_simple_moving_averages(test_data, 5, 5)
        assert_nil results
    end

    test "will return exponential moving averages" do
        test_data = [24, 21, 19, 23, 34, 29, 27, 25, 18, 16, 18]
        results = MovingAverage.get_exponential_moving_averages(test_data, 5, 5)
        assert_equal results, [23.02, 22.53, 23.3, 25.45, 26.67]
    end

    test "will also return nil if the sample size is not large enough" do 
        test_data = [24, 21, 19, 23, 34, 29]
        results = MovingAverage.get_exponential_moving_averages(test_data, 5, 5)
        assert_nil results
    end
end