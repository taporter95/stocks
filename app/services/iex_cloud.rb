module IexCloud
    LIST_TYPES = ['mostactive', 'gainers', 'losers', 'iexvolume', 'iexpercent'].freeze

    def IexCloud.get_list(type)
        return nil unless LIST_TYPES.include? type
        client = IEX::Api::Client.new
        # list = []
        return client.get("/stock/market/list/#{type}", token: Settings.iex.secret_token)
        # stocks.each do |stock|
        #     ohlc = client.ohlc(stock["symbol"])
        #     list << {
        #         symbol: stock["symbol"],
        #         companyName: stock["companyName"],
        #         open: ohlc.open&.price ? "$#{ohlc.open&.price}" : "No Data",
        #         close: ohlc.close&.price ? "$#{ohlc.close&.price}" : "No Data",
        #         high: ohlc.high ? "$#{ohlc.high}" : "No Data",
        #         low: ohlc.low ? "$#{ohlc.low}" : "No Data"
        #     }
        # end
        #return list
    end

    def IexCloud.get_info(ticker_symbol)
        client = IEX::Api::Client.new
        begin
            stock_data = {
                price: client.price(ticker_symbol),
                quote: client.quote(ticker_symbol),
                company: client.company(ticker_symbol),
                logo: client.logo(ticker_symbol)
            }
            return stock_data
        rescue => e  
            return nil
        end
    end

    def IexCloud.get_chart(ticker_symbol)
        client = IEX::Api::Client.new
        return client.chart(ticker_symbol, '3m', sort: "desc")
    end
end