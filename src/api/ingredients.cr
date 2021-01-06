require "kemal"

require "../repositories/ingredients"
require "../services/ingredients"

module Laspatule::API::Ingredients
  def self.setup(ingredients_repo)
    get "/ingredients/:id" do |env|
      id = env.params.url["id"].to_i
      service = Laspatule::Services::Ingredients.new(12, ingredients_repo)

      begin
        service.get_by_id(id).to_json, 404
      rescue Laspatule::Repositories::Ingredients::IngredientNotFoundError
        halt env, status_code: 404
      end
    end
  end
end
