$(document).on 'click', 'a.auth-popup', (e) ->
  e.preventDefault()
  $.oauthpopup
    path: $(this).attr('href')
    windowOptions: 'location=0,status=0,width=1024,height=400'
