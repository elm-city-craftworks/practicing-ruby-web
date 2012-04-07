class PR.ShareBox
  constructor: ->
    $.facebox { div: '#share-box' }, 'share-box'

    $('#facebox .read button').on 'click', (e) ->
      $(document).trigger 'close.facebox'
      e.preventDefault()

    $('#facebox .subscribe button').on 'click', (e) ->
      # Subscribe Link ???
      window.location = "http://practicingruby.com"