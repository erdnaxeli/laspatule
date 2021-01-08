require "../spec_helper.cr"

AUBERGINE = Laspatule::Models::Ingredient.new(id: 42, name: "aubergine")
STEP1     = Laspatule::Models::Recipe::Step.new(id: 1, instruction: "couper l'aubergine en morceaux")
STEP2     = Laspatule::Models::Recipe::Step.new(id: 2, instruction: "ajouter l'aubergine à la marmite")
SECTION   = Laspatule::Models::Recipe::Section.new(id: 1, title: "L'aubergine")
USER      = Laspatule::Models::User.new(id: 1, name: "user")

CREATE_AUBERGINE = Laspatule::Models::CreateIngredient.new(name: "aubergine")
