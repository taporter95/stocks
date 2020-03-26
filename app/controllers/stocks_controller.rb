class StocksController < ApplicationController
    def index
        if request.xhr?
            if params[:list_selection] == "submitted"
                list = current_user.stocks.all
            else
                list = Stock.get_list(params[:list_selection])
            end
            render json: {stocks_list: list}
        end
    end

    def show 
        @stock_data = stock.get_all_data
    end

    def create
        if current_user.tracking_symbol?(stock_params[:symbol])
            flash[:info] = "You are already tracking this symbol"
        else
            found_stock = Stock.find_or_create_by(stock_params)
            if found_stock.save
                found_stock.update_company_info
                current_user.stocks << found_stock
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
        @stock ||= Stock.find_or_initialize_by(id: params[:id])
    end
    helper_method :stock
end
