$(document).on 'click', 'a[data-hide]', (e) ->
  target = $(this).data('hide')
  window.scrollBy 0, $(target).outerHeight()
  e.preventDefault()
