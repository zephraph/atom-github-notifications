AtomGithubNotificationsView = require './atom-github-notifications-view'
{CompositeDisposable} = require 'atom'

module.exports = AtomGithubNotifications =
  atomGithubNotificationsView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @atomGithubNotificationsView = new AtomGithubNotificationsView(state.atomGithubNotificationsViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomGithubNotificationsView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-github-notifications:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomGithubNotificationsView.destroy()

  serialize: ->
    atomGithubNotificationsViewState: @atomGithubNotificationsView.serialize()

  toggle: ->
    console.log 'AtomGithubNotifications was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
