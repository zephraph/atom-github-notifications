module.exports =
class GithubNotificationsView
  constructor: (@side = 'right', @priority = 100) ->

    # Create root element
    @element = document.createElement 'div'
    @element.classList.add 'github-notifications'
    @element.classList.add 'inline-block'
    @element.onclick = ->
      require('shell').openExternal "https://github.com/notifications"

    @icon = document.createElement 'span'
    @icon.classList.add 'icon', 'icon-inbox'
    @element.appendChild @icon

  update: (notifications = []) ->
    if notifications.length > 0
      @icon.classList.add 'has-notifications'
      @icon.innerHTML = notifications.length
    else
      @icon.classList.remove 'has-notifications'
      @icon.innerHTML = ''

  # Tear down any state and detach
  destroy: ->
    @icon = null
    @element.remove()
    @element = null

  getElement: ->
    @element

  addTile: ->
    if @side is 'right'
      @tile = @statusBar?.addRightTile item: @element, priority: @priority
    else
      @tile = @statusBar?.addLeftTile item: @element, priority: @priority

  updatePosition: ->
    @tile?.destroy()
    @addTile()

  consumeStatusBar: (@statusBar) ->
    @addTile()
