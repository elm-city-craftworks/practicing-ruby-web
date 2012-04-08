class PR.RoboBar
  constructor: (sharePath) ->
    this._createGutter()
    this._createBar()

    @chippy  = new PR.RoboBar.Chippy(this)
    @share   = new PR.RoboBar.Share(this, sharePath)
    @visible = false

  show: ->
    @bar.css "bottom", "0px"

  hide: ->
    height = @bar.css('height')
    @bar.css "bottom", "-" + height

  toggle: =>
    if @visible
      @chippy.idle()
      this.hide()
      @share.toggle() if @share.visible
    else
      @chippy.activate()
      this.show()

    @visible = !@visible

  # Private Methods

  _createBar: ->
    @bar = $('<div/>', {
      id: 'robo-bar'
    })

    $('body').append @bar

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

class PR.RoboBar.Panel
  constructor: (@robobar, @id) ->
    @visible = false

  click: (e) =>
    this._createPanel() unless @panel?

    this.toggle()

    e.preventDefault()

  toggle: ->
    # Bar height + shadow + border
    robobarHeight = parseInt @robobar.bar.css('height')
    height        = parseInt @panel.height() + 10 + 4

    if @visible
      @panel.css 'bottom', "-#{height}px"
    else
      @robobar.toggle() unless @robobar.visible
      @panel.css 'bottom', "#{robobarHeight}px"

    @visible = !@visible

  html: (htmlContents) =>
    @content.html(htmlContents)

  # Private Methods

  _createPanel: ->
    @panel = $('<div/>', {
      id:    "robo-#{@id}",
      class: "robo-panel"
    })

    this._createCloseButton()
    this._createContentArea()

    @panel.insertBefore @robobar.bar

  _createCloseButton: ->
    @btnClose = $('<a/>', {
      class: 'robo-panel-close',
      href:  '#',
      title: 'Close'
    })

    @panel.append @btnClose

    @btnClose.on 'click', this.click

  _createContentArea: ->
    @content = $('<div/>', {
      class: 'robo-panel-content'
    })

    @panel.append @content

class PR.RoboBar.Share extends PR.RoboBar.Panel
  constructor: (@robobar, @sharePath) ->
    super @robobar, "share"

    this._createShareButton()

    @btnShare.on 'click', this.click

    $('a[data-share-link]').on 'click', (e) =>
      this.click(e)

  click: (e) =>
    super e

    this._loadContent()

    $('#robo-share-url input').select().focus() if @contentLoaded && @visible

  # Private Methods

  _loadContent: ->
    return if @contentLoaded

    @contentLoaded = true

    content = """
              <strong>Share with your friends</strong>
              <p>
                As a subscriber to Practicing Ruby, you can share this article
                with anyone you want! The link below will allow non-subscribers
                to view this content without signing up for an account.
              </p>
              <p>
                <span id='robo-share-url'>
                  <em>Loading your personal share url ...</em>
                </span>
              </p>
              <p>
                When someone visits this article via the link above, they will
                be presented with a short message about what Practicing Ruby
                is all about, and also will see your Github name so that they
                know who to thank for sharing. But with just a single click
                they will be able to start reading, so don't worry about
                sending your friends through some annoying registration process
                just to get at my content.
              </p>

              <p>Even though this is a paid service, I believe that <b>Sharing is
              Caring</b>. So please spread the love!</p>
              """

    this.html(content)

    this._loadShareUrl()

  _createShareButton: ->
    @btnShare = $('<button/>')

    @btnShare.text "Share with your friends"

    @robobar.bar.append @btnShare

  _loadShareUrl: ->
    $.ajax @sharePath, {
      dataType: 'json',
      success: (data) ->
        textField = $('<input/>', {
          type: 'text',
          value: data
        })

        $('#robo-share-url').html textField

        textField.select().focus()

        textField.on 'keydown click', (e) ->
          $(this).select().focus()
          e.preventDefault() unless e.metaKey
      error: (jqXHR, textStatus, errorThrown) ->
        $('#robo-share-url').text "Error loading share url: #{textStatus}"
    }
