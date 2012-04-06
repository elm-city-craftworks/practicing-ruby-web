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
    @chippy.show()

  # Private Methods

  _createBar: ->
    @bar = $('<div/>', {
      id: 'robo-bar'
    })

    @closeButton = $('<a/>', {
      id: 'close-robo-bar',
      href: '#'
    })

    @closeButton.text("Close")

    @closeButton.on 'click', (e) =>
      this.hide()
      e.preventDefault()

    @bar.append(@closeButton)

    $('body').append @bar

  _createGutter: ->
    @gutter = $('<div/>', {
      id: 'robo-bar-gutter'
    })

    $('body').append @gutter

class PR.RoboBar.Chippy
  constructor: (@robobar) ->
    this._create()

    @chippy.on 'click', this.click

  click: (e) =>
    width = @chippy.css 'width'
    @chippy.css 'right', "-" + width

    @robobar.show()

  show: =>
    @chippy.css 'right', "0px"

  # Private methods

  _create: ->
    @chippy = $('<div/>', {
      id: 'chippy'
    })

    $('body').append @chippy