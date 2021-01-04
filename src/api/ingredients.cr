require "kemal"

require "../repositories/ingredients"
require "../services/ingredients"

module Laspatule::API::Ingredients
  def self.setup(ingredients_repo)
    before_all "/ingredients/*" do |env|
    end

    get "/ingredients/:id" do |env|
      id = env.params.url["id"].to_i
      service = Laspatule::Services::Ingredients.new(12, ingredients_repo)
      service.get_by_id(id).to_json
    end
  end
end
