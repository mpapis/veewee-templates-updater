#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "veewee-templates-updater"
  s.version     = "1.0.0"
  s.author      = "Michal Papis"
  s.email       = "mpapis@gmail.com"
  s.homepage    = "https://github.com/mpapis/veewee-templates-updater"
  s.summary     =
  s.description = %q{Veewee templates updater. Easily update templates in the installed veewee gem.}

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = %w( veewee-templates-update )

  s.add_dependency "veewee", ">= 0.2.3"
  s.add_dependency "archive-tar-minitar"

  s.add_development_dependency "dtf"
end
