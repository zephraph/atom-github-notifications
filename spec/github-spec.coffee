GitHub = require '../lib/github'
notificationKey = '44b8240e5fbbfca6a71f18e1fad5c91d6bb57bef'

github = new GitHub
github.setAuthToken notificationKey

describe 'The GitHub API interface', ->

  passed = no
  items = null
  disposables = []

  afterEach ->
    for disposable in disposables
      disposable.dispose()

  it 'should receive notifications from GitHub', () ->
    runs ->
      disposables.push github.onDidUpdate ([route, response, info]) ->
        if response.statusCode is 200 and info.length >= 1
          items = info
          passed = yes

      disposables.push github.onDidError (error) ->
        console.log "Error: #{error}"

      github.request '/notifications'

    waitsFor ->
      passed
    , 'Notification should be received'
    , 1000

    runs ->
      expect(items).not.toBe null
