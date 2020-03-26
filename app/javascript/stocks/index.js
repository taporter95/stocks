  
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
        $row.append(buildLink(`/stocks/${data["id"]}`, data["symbol"]));
        $row.append(buildData(data["company_name"]));
        $row.append(buildData(data["exchange"]));
        $row.append(buildData(data["sector"]));
        $row.append(buildLink(data["website"], data["website"]));
        
        return $row;
    }

    function buildData(data) {
        if (data) {
            return $(`<td>${data}</td>`)
        } else {
            return $(`<td>No Data</td>`)
        }
    }

    function buildLink(href, data) {
        if (data) {
            return $(`<td><a href='${href}'>${data}</a></td>`)
        } else {
            return $(`<td>No Data</td>`)
        }
    }
});