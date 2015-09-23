Github = require '../../lib/github'

module.exports =
class GitHubStub extends Github

  request: (route, config) ->
    { response, info } = require "./github-routes#{route}"
    @emitter.emit 'did-update', [ route, response, info ]
