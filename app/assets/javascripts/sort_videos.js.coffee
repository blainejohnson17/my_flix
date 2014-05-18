$ ->
  $("#video_sort").change ->
    $.ajax
      url: '#{category_path}'
      data:
        page: 1
        sort_by: $("#video_sort").val()

      dataType: "script"

    return

  return