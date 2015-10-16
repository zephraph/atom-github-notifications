GithubNotificationsView = require './github-notifications-view'
{CompositeDisposable} = require 'atom'
GitHub = require './github'

require('marko/node-require').install()

github = new GitHub

module.exports = GithubNotifications =
  githubNotificationsView: null
  subscriptions: null
  hasWarned: no

  config:
    notificationAuthToken:
      type: 'string'
      description: 'A GitHub Personal Access Token with notification permissions.'
      default: ''
    pollRate:
      type: 'integer'
      description: 'The amount of time in seconds between checking for the latest updates'
      default: 60
    priority:
      type: 'integer'
      description: 'The higher the priority, the closer to the edge of the screen the icon will appear'
      default: 0
    side:
      type: 'string'
      description: 'Which side of the statusbar the icon should appear on'
      default: 'right'
      enum: ['left', 'right']

  activate: (state) ->
    @githubNotificationsView = new GithubNotificationsView(
      atom.config.get 'github-notifications.side'
      atom.config.get 'github-notifications.priority'
    )
    @githubNotificationsView.addTile()

    @subscriptions = new CompositeDisposable
    @subscriptions.add github.onDidUpdate ([route, response, info]) =>
      if route is '/notifications' and response.statusCode is 200
        @githubNotificationsView.update info

    @subscriptions.add github.onDidError (error) ->
      atom.notifications.addError error

    @subscriptions.add atom.commands.add 'atom-workspace',
      'github-notifications:refresh': ->
        @hasWarned = false
        @checkForNotifications()

    @subscriptions.add atom.config.onDidChange 'github-notifications', (event) =>
      if event.keyPath in ['github-notifications.side', 'github-notifications.priority']
        @githubNotificationsView.updatePosition()
      if event.keyPath is 'github-notifications.pollRate'
        @resetPoll()

    @checkForNotifications()
    @poll()

  poll: ->
    @timer = setInterval @checkForNotifications, parseInt(atom.config.get 'github-notifications.pollRate') * 1000

  resetPoll: ->
    @stopPoll()
    @poll()

  stopPoll: ->
    clearInterval @timer

  checkForNotifications: ->
    if github.hasAuthToken()
      github.request '/notifications'

    else
      authToken = atom.config.get 'github-notifications.notificationAuthToken'

      if authToken isnt ''
        github.setAuthToken authToken
        @checkForNotifications?()

      else if not @hasWarned
          atom.notifications.addWarning 'GithubNotifications package has no authorization token.'
          @hasWarned = true

  deactivate: ->
    @subscriptions.dispose()
    @githubNotificationsView.destroy()

  consumeStatusBar: (statusBar) ->
    @githubNotificationsView.consumeStatusBar statusBar
