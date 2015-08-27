module.exports =
class GithubNotificationsView
  constructor: ->

    # Create root element
    @element = document.createElement 'div'
    @element.classList.add 'github-notifications'
    @element.classList.add 'inline-block'

    @icon = document.createElement 'span'
    @icon.classList.add 'icon', 'icon-inbox'
    @element.appendChild @icon

  update: (notifications) ->
    if notifications.length > 0
      @element.classList.add 'has-notifications'
      @icon.innerHTML = notifications.length
    else
      @element.classList.remove 'has-notifications'
      @icon.innerHTML = ''

  # Tear down any state and detach
  destroy: ->
    @icon = null
    @element.remove()
    @element = null

  getElement: ->
    @element

  addTile: ->
    if atom.config.get('github-notifications.side') is 'right'
      @tile = @statusBar?.addRightTile item: @element, priority: atom.config.get 'github-notifications.priority'
    else
      @tile = @statusBar?.addLeftTile item: @element, priority: atom.config.get 'github-notifications.priority'

  updatePosition: ->
    @tile?.destroy()
    @addTile()

  consumeStatusBar: (@statusBar) ->
    @addTile()
