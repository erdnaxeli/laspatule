require "../spec_helper.cr"

require "../../src/models"

AUBERGINE = Laspatule::Models::Ingredient.new(id: 42, name: "aubergine")
STEP1     = Laspatule::Models::Recipe::Step.new(id: 1, instruction: "couper l'aubergine en morceaux")
STEP2     = Laspatule::Models::Recipe::Step.new(id: 2, instruction: "ajouter l'aubergine à la marmite")
