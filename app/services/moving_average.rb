module MovingAverage

    def MovingAverage.get_simple_moving_averages(closing_values, total_days, period) 
        simple_moving_averages = []
        if closing_values.length < total_days + period
            return nil
        end
        (0...total_days).each do |i|
            simple_moving_averages << sma(closing_values, i, period)
        end
        simple_moving_averages
    end

    def MovingAverage.get_exponential_moving_averages(closing_values, total_days, period)
        exponential_moving_averages = []
        if closing_values.length < total_days + period + 1
            return nil
        end
        #use sma to calculate first ema
        last_sma = sma(closing_values, total_days, period)
        first_ema = ema(closing_values[total_days-1], last_sma, period)
        exponential_moving_averages << first_ema
        (total_days-2).downto(0).each do |i|
            exponential_moving_averages << ema(closing_values[i], exponential_moving_averages.last, period)
        end
        exponential_moving_averages.reverse
    end 

    private

    def MovingAverage.sma(closing_values, for_day, period)
        current_sum = 0
        (0...period).each do |i|
            current_sum += closing_values[for_day + i]
        end
        (current_sum.to_f / period).round(2)
    end

    def MovingAverage.ema(price, last_ema, period)
        k = weighted_multiplyer(period)
        ((price * k) + (last_ema * (1 - k))).round(2)
    end

    def MovingAverage.weighted_multiplyer(period)
        (2.0 / (period + 1)).round(4)
    end
end