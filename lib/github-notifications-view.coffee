module.exports =
class GithubNotificationsView
  constructor: (serializedState) ->

    # Create root element
    @element = document.createElement('div')
    @element.classList.add('github-notifications')
    @element.classList.add('inline-block')

    icon = document.crateElement('span')
    icon.classList.add('icon icon-inbox')
    @element.appendChild(icon)

  show: ->
    @element.style.display = ''

  hide: ->
    @element.style.display = 'none'

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  consumeStatusBar: (statusBar) ->
