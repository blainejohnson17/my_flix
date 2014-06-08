$ ->
  $(".video_slider").slick
    infinite: true
    slidesToShow: 6
    slidesToScroll: 6
    speed: 400
  $(".slick-prev, .slick-next").css("display", "none")
  $(".video_slider").hover ->
    $(this).find(".slick-prev, .slick-next").fadeToggle()
  $(".lazy").slick
    lazyLoad: "ondemand"
    slidesToShow: 3
    slidesToScroll: 1