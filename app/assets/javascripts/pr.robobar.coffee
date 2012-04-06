class PR.RoboBar
  constructor: (@sharePath) ->
    console.debug @sharePath

    @chippy = new PR.RoboBar.Chippy(this)
    this._createGutter()
    this._createBar()

  show: ->
    @bar.css("bottom", "0px")

  hide: ->
    height = @bar.css('height')
    @bar.css("bottom", "-" + height)

  # Private Methods

  _createBar: ->
    @bar = $('<div/>', {
      id: 'robo-bar'
    })

    this._createShare()

    $('body').append @bar

  _createShare: ->
    @btnShare = $('<button/>', {
      id: 'share-article'
    })

    @btnShare.text("Share")

    @bar.append(@btnShare)

  _createGutter: ->
    @gutter = $('<div/>', {
      id: 'robo-bar-gutter'
    })

    $('body').append @gutter

class PR.RoboBar.Chippy
  constructor: (@robobar) ->
    this._create()

    @chippy.on 'click', this.toggle

  toggle: =>
    if @chippy.hasClass('active')
      @chippy.removeClass 'active'
      @robobar.hide()

      @chippy.attr('title', null)
    else
      @chippy.addClass 'active'
      @robobar.show()

      @chippy.attr('title', "Close")


  # Private methods

  _create: ->
    @chippy = $('<div/>', {
      id: 'chippy'
    })

    $('body').append @chippy