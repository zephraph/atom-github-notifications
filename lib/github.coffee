Promise = require 'bluebird'
request = Promise.promisify require 'request'

class GitHub

  constructor: (@config) ->
    defaultConfig =
      headers:
        'user-agent': 'atom-github-notifications'

  listNotifications: ->
    @config.url = ''
