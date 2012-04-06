class PR.RoboBar
  constructor: (@sharePath) ->
    @chippy  = new PR.RoboBar.Chippy(this)
    @visible = false

    this._createGutter()
    this._createBar()

  show: ->
    @bar.css "bottom", "0px"

  hide: ->
    height = @bar.css('height')
    @bar.css "bottom", "-" + height

  toggle: =>
    if @visible
      @chippy.idle()
      this.hide()
    else
      @chippy.activate()
      this.show()

    @visible = !@visible

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

    @btnShare.text("Share with your friends")

    @bar.append(@btnShare)

  _createGutter: ->
    @gutter = $('<div/>', {
      id: 'robo-bar-gutter'
    })

    $('body').append @gutter

class PR.RoboBar.Chippy
  constructor: (@robobar) ->
    this._create()

    @chippy.on 'click', @robobar.toggle

  idle: ->
    @chippy.removeClass 'active'
    @chippy.attr 'title', null

  activate: ->
    @chippy.addClass 'active'
    @chippy.attr 'title', 'Close'

  # Private methods

  _create: ->
    @chippy = $('<div/>', {
      id: 'chippy'
    })

    $('body').append @chippy