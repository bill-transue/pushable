$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pushable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pushable"
  s.version     = Pushable::VERSION
  s.authors     = ["Bill Transue"]
  s.email       = ["transue@gmail.com"]
  s.homepage    = "https://github.com/billy-ran-away/pushable"
  s.summary     = "Ah, push it pu-pu-push it real good. Your ActiveModels' changes to Backbone.js clients that is."
  s.description = "Push ActiveModel changes to Backbone Collections and Models though a Faye Pub/Sub server."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.12"
  s.add_dependency "faye"
  s.add_dependency "thin"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "debugger"
end
