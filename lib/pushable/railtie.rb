require 'pushable'
require 'rails'

module Pushable
  class Railtie < Rails::Railtie
    railtie_name :pushable

    rake_tasks do
      load "tasks/faye.rake"
    end
  end
end
