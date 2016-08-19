$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "forem/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "forem"
  s.version     = Forem::VERSION
  s.authors     = ["Daniel Romero"]
  s.email       = ["daniel.romero.esteban@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Forem."
  s.description = "TODO: Description of Forem."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry"
end
