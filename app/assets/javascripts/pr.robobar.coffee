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
                As a subscriber to Practicing Ruby, you are free to share our
                articles with your friends. The link below will allow
                non-subscribers to view this issue.
              </p>
              <p>
                <span id='robo-share-url'>
                  <em>Loading your personal share url ...</em>
                </span>
              </p>
              <p>
                Feel free to email this link, post it to a mailing list,
                tweet it, or otherwise distribute it any way you want.
                Sharing is caring!
              </p>
              <p>
                Be sure to note that when someone views a Practicing Ruby
                article via a share link you created, your github username will
                be displayed at the bottom of the page so that they know who to
                thank! Of course, no one except those who receive your link will
                know about your act of kindness, so those who prefer to keep a
                gruff public persona can still use this feature in private.
              </p>
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
          e.preventDefault()
      error: (jqXHR, textStatus, errorThrown) ->
        $('#robo-share-url').text "Error loading share url: #{textStatus}"
    }
