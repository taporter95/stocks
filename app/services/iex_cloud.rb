module IexCloud
    LIST_TYPES = ['mostactive', 'gainers', 'losers', 'iexvolume', 'iexpercent'].freeze

    def IexCloud.get_list(type)
        return nil unless LIST_TYPES.include? type
        client = IEX::Api::Client.new
        return client.get("/stock/market/list/#{type}", token: Settings.iex.secret_token)
    end

    def IexCloud.get_info(ticker_symbol)
        client = IEX::Api::Client.new
        stock_data = {
            price: client.price(ticker_symbol),
            quote: client.quote(ticker_symbol),
            company: client.company(ticker_symbol),
            logo: client.logo(ticker_symbol)
        }
        return stock_data
    end
end