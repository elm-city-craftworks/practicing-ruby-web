$(document).on 'click', 'a[data-toggle]', (e) ->
  target = $(this).data('toggle')
  $(target).toggleClass('visible')
  $.post '/toggle_nav'
  e.preventDefault()
