//= require jquery
//= require_self

$(function(){
  $('#mc-embedded-subscribe-form').submit(function(e){
    $.get('/subscribe.js', {email: $('#mce-EMAIL').val()});
  });
});