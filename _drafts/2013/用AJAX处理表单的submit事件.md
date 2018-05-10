Title: 用AJAX处理表单的submit事件

Date: 2012-11-02 15:53:07

    $("#id_item_search_form").submit(function () 

        var key = $("#id_item_barcode").val()

        if (key === ""

            return false

        var url = "/ship/ajax_item_info/?key="+key

        $.get(url,function (data) 

            $("#id_item_no").val(data.no)

            $("#id_item_ver").val(data.ver)

            $("#id_item_count").val(data.count)

        })

        return false;//need this to prevent submi

    });

注意最后一定要return false;否则表单仍然会被提交