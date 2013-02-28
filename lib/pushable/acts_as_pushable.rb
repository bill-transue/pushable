require 'net/http'

module Pushable
  module ActsAsPushable
    extend ActiveSupport::Concern

    def self.included(base)
      base.send :extend, ClassMethods
    end

    included do
      after_create  :push_create
      after_update  :push_update
      after_destroy :push_destroy
    end

    [:create, :update, :destroy].each do |event|
      define_method "push_#{event.to_s}" do
        Array.wrap(self.class.pushes[event]).each do |channel|
          ActionPusher.new.push event, evaluate(channel), self
        end
      end
    end

    def collection_channel
      self.class.name.underscore.pluralize
    end

    def instance_channel
      "#{self.class.name.underscore}_#{id}"
    end

    def evaluate(channel)
      case channel
      when :collections
        collection_channel
      when :instances
        instance_channel
      when Symbol #references association
        associate = send(channel)
        "#{associate.class.name.underscore}_#{associate.id}_#{self.class.name.underscore.pluralize}"
      when String
        eval '"' + channel + '"'
      when Proc
        evaluate channel.call(self)
      end
    end

    module ClassMethods
      def push(options={})
        @pushes = options
      end

      def pushes
        @pushes ||= { create: :collections,
                      update: [ :collections, :instances ],
                     destroy: :collections } #default events and channels
      end
    end

    module Rails
      module Faye
        mattr_accessor :address
        self.address = 'https://localhost:9292'
      end
    end
  end
end

ActiveModel::Base.send :include, Pushable::ActsAsPushable
