new AwesomeGrid('ul.menu', {desktop: 601}).gutters(0).grid(1).desktop(6, 0);
new AwesomeGrid('ul.column', {desktop: 601}).gutters(0).grid(1).desktop(2, 0);
new AwesomeGrid('ul.grid', {desktop: 601}).gutters(0).grid(5).desktop(9, 0);

$(window).on('load', function(){
  new AwesomeGrid('ul.menu', {desktop: 601}).gutters(0).grid(1).desktop(6, 0);
  new AwesomeGrid('ul.grid', {desktop: 601}).gutters(0).grid(5).desktop(9, 0);
});
