class Backbone.PushableCollection extends Backbone.Collection
  initialize: () ->
    window.FayeClient.subscribe "/sync/#{@channel()}", _.bind(@receive, @)

  receive: (message) ->
    @[message.event] message.object

  create: (attributes) ->
    model = new @model attributes
    @add model

  update: (attributes) ->
    model = @get attributes.id
    model.set attributes

  destroy: (attributes) ->
    @remove @get(attributes.id)
