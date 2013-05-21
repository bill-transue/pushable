$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pushable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pushable"
  s.version     = Pushable::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Pushable."
  s.description = "TODO: Description of Pushable."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.12"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "debugger"
end
