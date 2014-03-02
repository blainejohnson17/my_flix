jQuery ->
  $(".rateit.rateit-active").bind "rated reset", ->
    ri = $(this)
    $.post($(this).data('update-url'),
        video_id: $(this).data("video-id"),
        rating: $(this).rateit("value"))