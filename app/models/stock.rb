class Stock < ApplicationRecord
    validates :symbol, presence: true

    belongs_to :user

    def self.validate_symbol(symbol)
        client = IEX::Api::Client.new
        begin
            info = client.company(symbol)
            if info 
                return true
            else
                return false
            end
        rescue => e
            return false
        end
    end

    def update_company_info
        client = IEX::Api::Client.new
        info = client.company(self.symbol)
        self.update_attributes(company_name: info.company_name, exchange: info.exchange, sector: info.sector, website: info.website)
        self.save
    end

    def get_all_data
        client = IEX::Api::Client.new
        self.update_company_info
        chart_data = client.chart(self.symbol, '3m', sort: "desc")
        only_closing = chart_data.map {|m| m.close}
        smas = Stock.get_simple_moving_averages(only_closing, 30, 10)
        emas = Stock.get_exponential_moving_averages(only_closing, 30, 10)
        ema_chart_data = {}
        closing_chart_data = {}
        last_thirty = chart_data[0...30]
        last_thirty.each_with_index do |datapoint, i|
            ema_chart_data[datapoint.date] = emas[i]
            closing_chart_data[datapoint.date] = only_closing[i]
        end
        payload = {
            info: client.company(self.symbol),
            last_thirty: last_thirty,
            smas: smas,
            emas: emas,
            chart: [
                {name: "Closing Value", data: closing_chart_data},
                {name: "Exponential Moving Average", data: ema_chart_data}
            ],
            chart_min: only_closing[0...30].min < emas.min ? only_closing[0...30].min : emas.min,
            chart_max: only_closing[0...30].max > emas.max ? only_closing[0...30].max : emas.max
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

    private

    def self.sma(closing_values, for_day, period)
        current_sum = 0
        (0...period).each do |i|
            current_sum += closing_values[for_day + i]
        end
        (current_sum.to_f / period).round(2)
    end

    def self.ema(price, last_ema, period)
        k = weighted_multiplyer(period)
        ((price * k) + (last_ema * (1 - k))).round(2)
    end

    def self.weighted_multiplyer(period)
        (2.0 / (period + 1)).round(4)
    end
end
