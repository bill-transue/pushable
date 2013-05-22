class Backbone.PushableModel extends Backbone.Model
  initialize: () ->
    window.FayeClient.subscribe "/sync/#{@channel()}", _.bind(@receive, @)

  receive: (message) ->
    @[message.event] message.object

  create: (attributes) ->
    # A create event for a model shouldn't happen

  update: (attributes) ->
    @set attributes

  destroy: (attributes) ->
    @trigger 'destroy'
