require "../spec_helper.cr"

AUBERGINE = Laspatule::Models::Ingredient.new(id: 42, name: "aubergine")
STEP1     = Laspatule::Models::Recipe::Step.new(id: 1, instruction: "couper l'aubergine en morceaux")
STEP2     = Laspatule::Models::Recipe::Step.new(id: 2, instruction: "ajouter l'aubergine à la marmite")
SECTION   = Laspatule::Models::Recipe::Section.new(id: 1, title: "L'aubergine")
USER      = Laspatule::Models::User.new(id: 1, name: "user")

CREATE_AUBERGINE        = Laspatule::Models::CreateIngredient.new(name: "aubergine")
CREATE_RECIPE_AUBERGINE = Laspatule::Models::CreateRecipe::CreateIngredient.new(
  quantity: "1",
  ingredient_id: 1,
)
CREATE_STEP = Laspatule::Models::CreateRecipe::CreateStep.new(
  instruction: "couper l'aubergine en morceaux",
)
CREATE_SECTION = Laspatule::Models::CreateRecipe::CreateSection.new(
  title: "l'aubergine",
  steps: [CREATE_STEP],
)
