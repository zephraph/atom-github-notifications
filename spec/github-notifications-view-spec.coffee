GithubNotificationsView = require '../lib/github-notifications-view'
notifications = require './fixtures/notifications.json'

describe 'GithubNotificationsView', ->
  [statusBar, view] = []

  beforeEach ->
    jasmine.attachToDOM atom.views.getView atom.workspace

    waitsForPromise ->
      atom.packages.activatePackage 'status-bar'

    runs ->
      statusBar = atom.packages.getActivePackage('status-bar').mainModule.provideStatusBar()
      view = new GithubNotificationsView
      view.consumeStatusBar statusBar

  afterEach ->
    view.destroy()

  it 'should show the notification icon if there are notifications', ->
    elements = []

    view.update notifications
    statusBar.getRightTiles().forEach (tile) ->
      elements.push tile.item
    expect(elements).toContain(view.element)
    expect(view.icon.classList.contains 'has-notifications').toBe true

  it 'should not show the notification icon if there are no notifications', ->
    elements = []

    view.update()
    statusBar.getRightTiles().forEach (tile) ->
      elements.push tile.item
    expect(elements).toContain(view.element)
    expect(view.icon.classList.contains 'has-notifications').toBe false
