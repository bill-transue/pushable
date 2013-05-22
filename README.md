# Pushable

[Ah, push it, pu-pu-push it real good!](http://www.youtube.com/watch?v=vCadcBR95oU)

![Salt-n-Pepper](http://1.bp.blogspot.com/_1e1s_bYTxyE/TEZUEini5hI/AAAAAAAABIc/QzKyLsLJCOs/s1600/Salt-n-Pepa_l.jpg)

Push changes in your ActiveModels to Backbone.js clients' models and collections.

Overview
--------

At this point there are three ActiveModel events that can be pushed out
to the Faye server, creation, updat-uhh-ion, and deletion. They can
pushed to two channels, collection channels and instance channels. For
example if you had a family model and it has_many member models you
might have a Backbone family collection, when a new member was born,
you're family Backbone collection would be notified via the collection
channel, but other families don't need to be notified of the new member.
So you can scope a model's collection channel by defining a
collection_channel method in both the ActiveModel and the Backbone
collection. Similarly you could customize the instance channel used with
instance_channel methods. As usual the code speaks for itself:

    class Family < ActiveRecord::Base
      attr_accessible :name
      has_many :members
    end

    class Member < ActiveRecord::Base
      attr_accessible :name, :family_id
      belongs_to :family

      push :create  => :collections,
           :update  => [ :collections, :instances ],
           :destroy => [ :collections, :instances ]

      def collection_channel
        "family_#{family_id}_members"
      end
    end

    class Family extends Backbone.PushableCollection
      channel: -> "family_#{@id}_members"

      url: ->
        if @id
          '/families/' + @id + '/members.json'

      model: Member

      initialize: (members, options) -> # members is actually options if not initialized with members
        try
          @id = (members || options).id
        catch TypeError
          throw "MissingFamilyID"
        super()

    class Member extends Backbone.PushableModel
      channel: -> "member_#{@id}"

      url: ->
        if @isNew()
          "/families/#{@family_id}/members.json"
        else
          "/members/#{@id}.json"

Starting the Faye Server
------------------------
Start a Faye server instance with...

    rake faye:start

This rake task supports the following options:
 * `verbose=true`
 * `port=9292` 9292 is the default
 * `key=server.key` For an SSL key
 * `cert=server.crt` For an SSL certificate

Todo
----

 * Write some specs
 * Flesh the docs out more, an example app even
