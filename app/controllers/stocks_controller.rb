class StocksController < ApplicationController
    def index
    end

    def show 
        @stock_data = Stock.get_all_data(stock.symbol)
    end

    def create
        if IexCloud.get_info(stock_params[:symbol])
            new_stock = current_user.stocks.new
            new_stock.assign_attributes(stock_params)
            new_stock.save
            flash[:success] = "#{stock_params[:symbol]} Submitted"
        else 
            flash[:alert] = "Unable to find stock with symbol: #{stock_params[:symbol]}"
        end
        redirect_to root_path
    end

    private 

    def stock_params
        params.require(:stock).permit(:symbol)
    end

    def stocks
        @stocks ||= current_user.stocks.all.order(symbol: :asc)
    end
    helper_method :stocks

    def stock
        @stock ||= Stock.find_or_initialize_by(id: params[:id])
    end
    helper_method :stock
end
