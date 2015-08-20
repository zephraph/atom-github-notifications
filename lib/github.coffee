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
      url: 'https://api.github.com/v3'
      headers:
        'User-Agent': 'atom-github-notifications'
        'Accept': 'application/vnd.github.v3+json'

    @config = _.merge defaultConfig, config

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
      .then (response, body) ->
        if response.statusCode is 200
          # parse body json
          info = JSON.parse body

          # Store etag header (if present)
          @etag[route] = response.headers.ETag

          # Emit update
          @emitter.emit 'did-update', route, response, info

      .error (error) ->
        @emitter.emit 'did-error', error

  onDidUpdate: (callback) ->
    @emitter.on 'did-update', callback

  onDidError: (callback) ->
    @emitter.on 'did-error', callback
