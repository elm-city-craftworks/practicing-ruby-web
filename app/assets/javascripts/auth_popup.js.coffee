$(document).on 'click', 'a.auth-popup', (e) ->
  e.preventDefault()
  $.oauthpopup path: $(this).attr('href')
