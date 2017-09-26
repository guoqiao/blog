Title: 在Django中使用AJAX

Date: 2012-11-02 15:23:39

## Javascript的写法：


`   

    {% block js %}

    $(function() 

        $("#id_box_type").change(function () 

            var box_type_id = $(this).val()

            if (box_type_id === ""

                return

            $.get("/ship/ajax_box_info/"+box_type_id+"/",function (data) 

                $("#id_length").val(data.length)

                $("#id_width").val(data.width)

                $("#id_height").val(data.height)

                $("#id_weight").val(data.weight)

            })

        })

    })

    {% endblock %}

`


## view 的写法：

        import jso

        from django.http import HttpRespons

        .....

        def ajax_box_info(request,box_type_id)

            box_type = BoxType.objects.get(id=box_type_id

            box_type_info = 

                'length':box_type.length

                'width':box_type.width

                'height':box_type.height

                'weight':box_type.weight

                

            data = json.dumps(box_type_info

            return HttpResponse(data,mimetype='application/json')

## 要点

*   view这边需要将数据转为字典，进而转而json格式

*   mimetype='application/json'
