require "kemal"

require "../services/recipes"

module Laspatule::API::Recipes
  def self.setup(recipes_repo)
    get "/recipes" do |_|
      service = Laspatule::Services::Recipes.new(12, recipes_repo)
      page = service.get_all(20)
      page.to_json
    end

    post "/recipes" do |env|
      if env.request.headers["content-type"]?.try &.downcase != "application/json"
        halt env, status_code: 415
      end

      recipe = Laspatule::Models::CreateRecipe.from_json(
        env.request.body.not_nil!.gets_to_end
      )
      if (errors = recipe.validate).size > 0
        halt env, status_code: 400, response: errors.to_json
      end

      service = Laspatule::Services::Recipes.new(12, recipes_repo)

      begin
        service.create(recipe).to_json
      rescue Laspatule::Repositories::Recipes::DuplicatedRecipeError
        halt env, status_code: 409
      end
    end
  end
end
