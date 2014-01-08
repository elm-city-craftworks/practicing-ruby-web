$(document).on 'click', "a[href='/subscribe']", (e) ->
  e.preventDefault()
  $.facebox {ajax: '/subscribe'}, 'redirect-warning'
  setTimeout ->
    window.location.href = '/login'
  , 5000
