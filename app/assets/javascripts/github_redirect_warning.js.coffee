$(document).on 'click',
  "a[href='/subscriptions/new'][data-redirect-warning='true']",
  (e) ->
    e.preventDefault()
    $.facebox {ajax: '/subscriptions/redirect'}, 'redirect-warning'
    setTimeout ->
      window.location.href = '/login'
    , 5000
