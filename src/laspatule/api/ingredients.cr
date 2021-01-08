require "kemal"

require "../repositories/ingredients"
require "../services/ingredients"

module Laspatule::API::Ingredients
  def self.setup(ingredients_repo)
    get "/ingredients/:id" do |env|
      id = env.params.url["id"].to_i
      service = Laspatule::Services::Ingredients.new(12, ingredients_repo)

      begin
        service.get_by_id(id).to_json
      rescue Laspatule::Repositories::Ingredients::IngredientNotFoundError
        halt env, status_code: 404
      end
    end

    post "/ingredients" do |env|
      if env.request.headers["content-type"]?.try &.downcase != "application/json"
        halt env, status_code: 415
      end

      ingredient = Laspatule::Models::CreateIngredient.from_json(
        env.request.body.not_nil!.gets_to_end
      )
      if (errors = ingredient.validate).size > 0
        halt env, status_code: 400, response: errors.to_json
      end

      service = Laspatule::Services::Ingredients.new(12, ingredients_repo)

      begin
        service.create(ingredient)
      rescue Laspatule::Repositories::Ingredients::DuplicatedIngredientError
        halt env, status_code: 409
      end
    end
  end
end
