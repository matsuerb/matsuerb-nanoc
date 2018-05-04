$(function() {

  //ページ内スクロール
  $("a").click(function () {
    var mark = $(".mark").offset().top;
    var id = $(this).attr("href");
    if (id == '#') {
      return;
    }
    var point = $(id).offset().top;
    $('html,body').animate({ scrollTop: point - 120 }, 'fast');
    return false;
  });

});