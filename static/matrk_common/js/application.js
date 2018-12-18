$(function() {

  //ページ内スクロール
  $(".menu a").on("click", function () {
    var mark = $(".mark").offset().top;
    var id = $(this).attr("href");
    var point = 120;
    try {
      point = $(id).offset().top;
    } catch(e) {
      // $('#') は例外になるため無視。
    }
    $('html,body').animate({ scrollTop: point - 120 }, 'fast');
    return false;
  });

});
