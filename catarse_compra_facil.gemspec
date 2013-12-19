$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "catarse_compra_facil/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "catarse_compra_facil"
  s.version     = CatarseCompraFacil::VERSION
  s.authors     = "EdgeInnovation"
  s.email       = "andre.cavalheiro@edgeinnovation.pt"
  s.homepage    = "http://www.edgeinnovation.eu"
  s.summary     = "Engine to pay with MultiBanco portuguese gateway payments"
  s.description = "Do payments with MB"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.13"
  s.add_dependency "savon", "~> 2.3.2"

  s.add_development_dependency "sqlite3"

  s.add_development_dependency "savon", "~> 2.3.2"
end
