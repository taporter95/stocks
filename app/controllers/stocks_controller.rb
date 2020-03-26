class StocksController < ApplicationController
    def index
    end

    def show 
        @stock_data = stock.get_all_data
    end

    def create
        if current_user.tracking_symbol?(stock_params[:symbol])
            flash[:info] = "You are already tracking this symbol"
        else
            stock.assign_attributes(stock_params)
            if stock.save
                stock.update_company_info
                flash[:success] = "#{stock_params[:symbol]} Submitted"
            else
                flash[:alert] = "Unable to find stock with symbol: #{stock_params[:symbol]}"
            end
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
        @stock ||= current_user.stocks.find_or_initialize_by(id: params[:id])
    end
    helper_method :stock
end
