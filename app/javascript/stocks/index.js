$(document).on('turbolinks:load', function() {
    $(".list-select").on("click", function() {
        updateList($(this));
    });

    function updateList(selection) {
        $.ajax({
            data: {
                "list_selection": selection.val()
            },
            success: function(response) {
                var stocks = response["stocks_list"];
                $("#stock-list-body").empty();
                if (stocks) {
                    for(var i = 0; i < stocks.length; i++){
                        var $new_row = buildRow(stocks[i]);
                        $("#stock-list-body").append($new_row);
                    }
                } else {
                    $("#stock-list-body").append($("<tr><td>No Data</td><tr>"))
                }
            },
            error: function(xhr, status, error) {
                console.error('AJAX Error: ' + status + error);
            }
        });
    }

    function buildRow(data) {
        var $row = $("<tr></tr>");
        $row.append($(`<td><a href='/stocks/info?ticker=${data["symbol"]}'>${data["symbol"]}</a></td>`));
        $row.append($(`<td>${data["companyName"]}</td>`));
        
        return $row;
    }
});