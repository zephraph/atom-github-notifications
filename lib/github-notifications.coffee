GithubNotificationsView = require './github-notifications-view'
{CompositeDisposable} = require 'atom'

module.exports = GithubNotifications =
  githubNotificationsView: null
  modalPanel: null
  subscriptions: null

  config:
    notificationAuthToken:
      type: 'string'
      description: 'A GitHub Personal Access Token with notification permissions.'

  activate: (state) ->
    @githubNotificationsView = new githubNotificationsView(state.githubNotificationsViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @githubNotificationsView.getElement(), visible: false)

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @githubNotificationsView.destroy()

  serialize: ->
    githubNotificationsViewState: @githubNotificationsView.serialize()

  toggle: ->
    console.log 'GithubNotifications was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  consumeStatusBar: (statusBar) ->
    @githubNotificationsView.consumeStatusBar statusBar
