$(document).on 'click', 'a[data-toggle]', (e) ->
  target = $(this).data('toggle')
  $(target).toggleClass('visible')
  e.preventDefault()
