# -*- encoding: utf-8 -*-
name = 'ripl-profiles'

require 'rubygems' unless defined? Gem
require File.dirname(__FILE__) + "/lib/ripl/profiles"
 
Gem::Specification.new do |s|
  s.name        = name
  s.version     = Ripl::Profiles::VERSION
  s.authors     = ["Jan Lelis"]
  s.email       = "mail@janlelis.de"
  s.homepage    = "http://github.com/janlelis/" + name
  s.summary     = "This ripl plugin adds a --profile option to ripl that loads profile files in ~/.ripl/profiles."
  s.description = "This ripl plugin adds a --profile option to ripl that loads profile files in ~/.ripl/profiles before starting ripl."
  s.required_rubygems_version = ">= 1.3.6"
  s.add_dependency 'ripl', '>= 0.2.7'
  s.files = Dir.glob(%w[{lib,test}/**/*.rb bin/* [A-Z]*.{txt,rdoc} ext/**/*.{rb,c} **/deps.rip]) + %w{Rakefile .gemspec}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE.txt"]
  s.license = 'MIT'
end
