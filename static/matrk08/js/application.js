$(function() {

  //ページ内スクロール
  $("a").click(function () {
    var mark = $(".mark").offset().top;
    var point = $($(this).attr("href")).offset().top;
    $('html,body').animate({ scrollTop: point - 120 }, 'fast');
    return false;
  });

});