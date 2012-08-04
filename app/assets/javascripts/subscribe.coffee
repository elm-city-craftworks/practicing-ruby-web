$ ->
  $('#mc-embedded-subscribe-form').submit (e)->
    $.get '/new_subscription.js', { email: $('#mce-EMAIL').val() }