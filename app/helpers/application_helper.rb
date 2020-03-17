module ApplicationHelper
    def submit_symbol_button
        if controller_name == "stocks" && action_name == "index" 
            return '<button type="button" class="btn btn-sm btn-primary" data-toggle="modal" data-target="#addSymbolModal">
                        Submit Symbol
                    </button>'.html_safe
        end
    end
end
