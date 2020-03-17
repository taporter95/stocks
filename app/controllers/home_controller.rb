class HomeController < ApplicationController
  def index
    if request.xhr?
        render json: {stocks_list: IexCloud.get_list(params[:list_selection])}
    end
    if params[:symbol]
        redirect_to info_stocks_path(symbol: params[:symbol])
    end
    @list = IexCloud.get_list('mostactive')
  end
end
