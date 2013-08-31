$(document).on 'click', 'a[data-toggle]', (e) ->
  target = $(this).data('toggle')
  $(target).toggle()
  e.preventDefault()
