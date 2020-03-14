class StocksController < ApplicationController
    def index
        @list = IexCloud.get_list('mostactive')
    end

    def show

    end

    def info 
        @stock_info = IexCloud.get_info(stock_params[:ticker])
    end

    private 

    def stock_params
        params.permit(:name, :ticker)
    end
end
