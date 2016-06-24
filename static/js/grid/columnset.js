/* column set */
var MemberList = (function(){
  var items = 32;
  if( window.matchMedia('(max-width:600px)').matches ) {items = 10;}
  var arr = [];
  for (var i = 0; i < 32; i++) {arr.push(i);}
  arr.sort(function() {
    return Math.random() - Math.random();
  });

  $(".grid").empty();
  for(i=0; i < items; i++) {
    $(".grid").append('<li><img src="/images/member/member_' + ('0' + arr[i]).slice(-2) + '.png" alt="*" /></li>');
  }
});
MemberList();

new AwesomeGrid('ul.menu', {desktop: 601}).gutters(0).grid(1).desktop(8, 0);
new AwesomeGrid('ul.column', {desktop: 601}).gutters(0).grid(1).desktop(3, 0);
new AwesomeGrid('ul.grid', {desktop: 601}).gutters(0).grid(5).desktop(6, 0);

$(window).load(function(){
  new AwesomeGrid('ul.menu', {desktop: 601}).gutters(0).grid(1).desktop(8, 0);
  new AwesomeGrid('ul.grid', {desktop: 601}).gutters(0).grid(5).desktop(6, 0);
});

var timer = false;
$(window).resize(function() {
  if( window.matchMedia('(max-width:600px)').matches ) {
    new AwesomeGrid('ul.grid', {desktop: 601}).gutters(0).grid(5).desktop(6, 0);
  } else {
    if (timer !== false) {
        clearTimeout(timer);
    }
    timer = setTimeout(function() {
      MemberList();
      new AwesomeGrid('ul.grid', {desktop: 601}).gutters(0).grid(5).desktop(6, 0);
    }, 200);
  }
  
});
