describe Laspatule::Repositories::DB::Recipes do
  describe "#create" do
    it "creates a new recipe and returns its id" do
      with_recipes_repo do |repo, ingredients, db|
        aubergine = Laspatule::Models::CreateIngredient.new(name: "aubergine")
        courgette = Laspatule::Models::CreateIngredient.new(name: "courgette")
        aubergine_id = ingredients.create(aubergine)
        courgette_id = ingredients.create(courgette)

        recipe = Laspatule::Models::CreateRecipe.new(
          title: "Ratatouille",
          ingredients: [
            Laspatule::Models::CreateRecipe::CreateIngredient.new(
              quantity: "1",
              ingredient_id: aubergine_id.not_nil!,
            ),
            Laspatule::Models::CreateRecipe::CreateIngredient.new(
              quantity: "1",
              ingredient_id: courgette_id.not_nil!,
            ),
          ],
          sections: [
            Laspatule::Models::CreateRecipe::CreateSection.new(
              title: "l'aubergine",
              steps: [
                Laspatule::Models::CreateRecipe::CreateStep.new(
                  instruction: "couper l'aubergine en cubes"
                ),
                Laspatule::Models::CreateRecipe::CreateStep.new(
                  instruction: "faire revenir rapidement à la poêle"
                ),
                Laspatule::Models::CreateRecipe::CreateStep.new(
                  instruction: "ajouter le tout à la marmite"
                ),
              ]
            ),
            Laspatule::Models::CreateRecipe::CreateSection.new(
              title: "la courgette",
              steps: [
                Laspatule::Models::CreateRecipe::CreateStep.new(
                  instruction: "couper la courgette en tranches"
                ),
                Laspatule::Models::CreateRecipe::CreateStep.new(
                  instruction: "faire revenir rapidement à la poêle"
                ),
                Laspatule::Models::CreateRecipe::CreateStep.new(
                  instruction: "ajouter le tout à la marmite"
                ),
              ]
            ),
          ]
        )
        id = repo.create(recipe, 12)

        db.using_connection do |cnn|
          r = cnn.query_all(
            "SELECT id, title, user_id FROM recipe",
            as: {id: Int64, title: String, user_id: Int64},
          )
          r.size.should eq(1)
          recipe_id = r[0]["id"]
          id.should eq(recipe_id.to_i)
          r[0]["title"].should eq("Ratatouille")
          r[0]["user_id"].should eq(12)

          r = cnn.query_all(
            "SELECT quantity, ingredient_id FROM recipe_ingredient",
            as: {quantity: String, ingredient_id: Int32},
          )
          r.size.should eq(2)
          r.to_set.should eq(
            Set{
              {quantity: "1", ingredient_id: aubergine_id},
              {quantity: "1", ingredient_id: courgette_id},
            }
          )

          r = cnn.query_all(
            "SELECT title, recipe_id FROM recipe_section",
            as: {title: String, recipe_id: Int64},
          )
          r.size.should eq(2)
          r.to_set.should eq(
            Set{
              {title: "l'aubergine", recipe_id: recipe_id},
              {title: "la courgette", recipe_id: recipe_id},
            }
          )

          sections_ids = cnn.query_all("SELECT id FROM recipe_section", as: Int64)
          r = cnn.query_all(
            "SELECT section_id, instruction FROM recipe_step",
            as: {section_id: Int64, instruction: String},
          )
          r.size.should eq(6)
          h = Hash(Int64, Array(String)).new { |h_, k| h_[k] = Array(String).new }
          r.each { |step| h[step["section_id"]] << step["instruction"] }
          h.keys.to_set.should eq(sections_ids.to_set)
          h.each do |section_id, instructions|
            if section_id == h.keys.min
              instructions.to_set.should eq(
                Set{
                  "couper l'aubergine en cubes",
                  "faire revenir rapidement à la poêle",
                  "ajouter le tout à la marmite",
                }
              )
            else
              instructions.to_set.should eq(
                Set{
                  "couper la courgette en tranches",
                  "faire revenir rapidement à la poêle",
                  "ajouter le tout à la marmite",
                }
              )
            end
          end
        end
      end
    end

    it "raises an error when a recipe with the same name already exists for the same user" do
      with_recipes_repo do |repo|
        recipe = Laspatule::Models::CreateRecipe.new(
          title: "Ratatouille",
          ingredients: Array(Laspatule::Models::CreateRecipe::CreateIngredient).new,
          sections: Array(Laspatule::Models::CreateRecipe::CreateSection).new,
        )

        repo.create(recipe, 12)
        expect_raises(Laspatule::Repositories::Recipes::DuplicatedRecipeError) do
          repo.create(recipe, 12)
        end
      end
    end

    it "does not raises an error when different user create a recipe with the same title" do
      with_recipes_repo do |repo|
        recipe = Laspatule::Models::CreateRecipe.new(
          title: "Ratatouille",
          ingredients: Array(Laspatule::Models::CreateRecipe::CreateIngredient).new,
          sections: Array(Laspatule::Models::CreateRecipe::CreateSection).new,
        )

        repo.create(recipe, 12)
        repo.create(recipe, 13)
      end
    end
  end
end
