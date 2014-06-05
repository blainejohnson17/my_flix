$ ->
  loading_videos = false
  $('a.load-more-videos').on 'inview', (e, visible) ->
    return if loading_videos or not visible
    loading_videos = true
    
    $.getScript $(this).attr('href'), ->
      loading_videos = false