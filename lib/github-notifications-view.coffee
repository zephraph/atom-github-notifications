module.exports =
class GithubNotificationsView
  constructor: ->

    # Create root element
    @element = document.createElement 'div'
    @element.classList.add 'github-notifications'
    @element.classList.add 'inline-block'

    @icon = document.createElement 'span'
    @icon.innerHTML = '5'
    @icon.classList.add 'icon', 'icon-inbox'
    @element.appendChild @icon

  show: ->
    @element.style.display = ''

  hide: ->
    @element.style.display = 'none'

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
