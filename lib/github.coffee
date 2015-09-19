_ = require 'lodash'
Promise = require 'bluebird'
request = Promise.promisify require 'request'
{Emitter} = require 'event-kit'

module.exports =
class GitHub

  constructor: (config) ->
    @emitter = new Emitter
    @etags = {}

    defaultConfig =
      url: 'https://api.github.com'
      headers:
        'User-Agent': 'atom-github-notifications'
        'Accept': 'application/vnd.github.v3+json'

    @config = _.merge defaultConfig, config

  hasAuthToken: ->
    @config.headers.Authorization?

  setAuthToken: (token) ->
    @config.headers.Authorization = "token #{token}"

  request: (route, config) ->
    # Temporarily store url variable
    currentUrl = @config.url
    @config.url += route

    if @etags[route]?
      @config.headers['If-None-Match'] = @etags[route]

    # Build payload
    payload = _.merge {}, @config, config

    # Restore config object
    @config.url = currentUrl
    delete @config.headers['If-None-Match']

    # perform request
    request payload
      .then ( [response, body] ) =>
        # parse body json
        try
          info = JSON.parse body
        catch error
          info = body

        # Store etag header (if present)
        @etags[route] = response.headers?.ETag

        # Emit update
        @emitter.emit 'did-update', [ route, response, info ]

      .error (error) =>
        @emitter.emit 'did-error', error

  onDidUpdate: (callback) ->
    @emitter.on 'did-update', callback

  onDidError: (callback) ->
    @emitter.on 'did-error', callback
