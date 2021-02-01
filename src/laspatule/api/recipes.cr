require "kemal"

require "../services/recipes"

module Laspatule::API::Recipes
  def self.setup(recipes_repo)
    get "/recipes" do |_|
      service = Laspatule::Services::Recipes.new(12, recipes_repo)
      page = service.get_all(20)
      page.to_json
    end

    get "/recipes/:id" do |env|
      id = env.params.url["id"].to_i
      service = Laspatule::Services::Recipes.new(12, recipes_repo)

      begin
        service.get_by_id(id).to_json
      rescue Laspatule::Repositories::Recipes::RecipeNotFoundError
        halt env, status_code: 404
      end
    end

    post "/recipes" do |env|
      recipe = Laspatule::Models::CreateRecipe.from_json(
        env.request.body.not_nil!.gets_to_end
      )
      if (errors = recipe.validate).size > 0
        halt env, status_code: 400, response: errors.to_json
      end

      user_id = env.get("user_id").as(Int32)
      service = Laspatule::Services::Recipes.new(user_id, recipes_repo)

      begin
        service.create(recipe).to_json
      rescue Laspatule::Repositories::Recipes::DuplicatedRecipeError
        halt env, status_code: 409
      end
    end
  end
end
