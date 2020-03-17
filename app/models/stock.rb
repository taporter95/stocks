class Stock < ApplicationRecord
    validates :symbol, presence: true

    belongs_to :user

    def self.get_all_data(symbol)
        chart_data = IexCloud.get_chart(symbol)
        only_closing = chart_data.map {|m| m.close}
        smas = get_simple_moving_averages(only_closing, 30, 10)
        emas = get_exponential_moving_averages(only_closing, 30, 10)
        sma_chart_data = {}
        ema_chart_data = {}
        last_thirty = chart_data[0...30]
        last_thirty.reverse.each_with_index do |datapoint, i|
            sma_chart_data[datapoint.date] = smas[i]
            ema_chart_data[datapoint.date] = emas[i]
        end
        payload = {
            info: IexCloud.get_info(symbol),
            last_thirty: last_thirty,
            smas: smas,
            emas: emas,
            sma_chart: {
                data: sma_chart_data,
                graph_min: graph_min(smas),
                graph_max: graph_max(smas)
            },
            ema_chart: {
                data: ema_chart_data,
                graph_min: graph_min(emas),
                graph_max: graph_max(emas)
            }
        }
    end

    def self.get_simple_moving_averages(closing_values, total_days, period) 
        simple_moving_averages = []
        if closing_values.length < total_days + period
            return nil
        end
        (0...total_days).each do |i|
            simple_moving_averages << sma(closing_values, i, period)
        end
        simple_moving_averages
    end

    def self.get_exponential_moving_averages(closing_values, total_days, period)
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

    def self.graph_min(data)
        gmin = 0
        magnitude = 10
        minimum = data.min.floor
        while minimum % magnitude != minimum
            magnitude *= 10
        end
        magnitude /= 10
        gmin = minimum - (minimum % magnitude)
    end

    def self.graph_max(data)
        gmax = 0
        magnitude = 10
        maximum = data.max.ceil
        while maximum % magnitude != maximum
            magnitude *= 10
        end
        magnitude /= 10
        gmax = maximum + (magnitude - (maximum % magnitude))
    end

    private 

    def self.sma(closing_values, for_day, period)
        current_sum = 0
        (0...period).each do |i|
            current_sum += closing_values[for_day + i]
        end
        (current_sum / period).round(2)
    end

    def self.ema(price, last_ema, period)
        k = weighted_multiplyer(period)
        ((price * k) + (last_ema * (1 - k))).round(2)
    end

    def self.weighted_multiplyer(period)
        (2.0 / (period + 1)).round(4)
    end
end
