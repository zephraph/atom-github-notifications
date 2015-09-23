module.exports =
class GithubNotificationsView
  constructor: (@side = 'right', @priority = 100) ->
    console.log 'GithubNotificationsView.constructor:', @side, @priority

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
    console.log 'GithubNotificationsView.update:', notifications
    if notifications.length > 0
      @icon.classList.add 'has-notifications'
      @icon.innerHTML = notifications.length
    else
      @icon.classList.remove 'has-notifications'
      @icon.innerHTML = ''

  # Tear down any state and detach
  destroy: ->
    console.log 'GithubNotificationsView.destroy'
    @icon = null
    @element.remove()
    @element = null

  getElement: ->
    console.log 'GithubNotificationsView.getElement'
    @element

  addTile: ->
    console.log 'GithubNotificationsView.addTile'
    if @side is 'right'
      @tile = @statusBar?.addRightTile item: @element, priority: @priority
    else
      @tile = @statusBar?.addLeftTile item: @element, priority: @priority

  updatePosition: ->
    console.log 'GithubNotificationsView.updatePosition'
    @tile?.destroy()
    @addTile()

  consumeStatusBar: (@statusBar) ->
    console.log 'GithubNotificationsView.consumeStatusBar'
    @addTile()
