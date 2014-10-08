$(document).on 'click',
  "a[href='/subscriptions/new'][data-redirect-warning='true']",
  (e) ->
    e.preventDefault()
    $.facebox {ajax: '/subscriptions/redirect'}, 'redirect-warning'
