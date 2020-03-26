class Stock < ApplicationRecord
    validates :symbol, presence: true
    validates :symbol, uniqueness: true
    validate :symbol_exists

    has_many :user_stocks
    has_many :users, through: :user_stocks

    LIST_TYPES = ['mostactive', 'gainers', 'losers'].freeze

    def self.get_list(list_type)
        return nil unless LIST_TYPES.include? list_type
        client = IEX::Api::Client.new
        results = client.get("/stock/market/list/#{list_type}", token: Settings.iex.secret_token)
        requested_symbols = results.map {|m| m["symbol"]}
        list = Stock.where(symbol: requested_symbols).to_a
        existing_symbols = list.map {|m| m.symbol}
        needed_symbols = (requested_symbols - existing_symbols).uniq
        needed_symbols.each do |symbol|
            stock = Stock.find_or_create_by(symbol: symbol)
            stock.update_company_info
            list << stock
        end
        list
    end

    def symbol_exists
        client = IEX::Api::Client.new
        begin
            info = client.company(symbol)
        rescue => e
            errors.add(:symbol, "does not exist")
        end
    end

    def update_company_info
        client = IEX::Api::Client.new
        info = client.company(self.symbol)
        self.update_attributes(company_name: info.company_name, exchange: info.exchange, sector: info.sector, website: info.website)
    end

    def get_all_data
        client = IEX::Api::Client.new
        chart_data = client.chart(self.symbol, '3m', sort: "desc")
        only_closing = chart_data.map {|m| m.close}
        smas = MovingAverage.get_simple_moving_averages(only_closing, 30, 10)
        emas = MovingAverage.get_exponential_moving_averages(only_closing, 30, 10)
        ema_chart_data = {}
        closing_chart_data = {}
        last_thirty = chart_data[0...30]
        last_thirty.each_with_index do |datapoint, i|
            ema_chart_data[datapoint.date] = emas[i]
            closing_chart_data[datapoint.date] = only_closing[i]
        end
        {
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
end
