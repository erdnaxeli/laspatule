require "swagger"
require "swagger/http/handler"

module Laspatule::API::Doc
  def self.setup
    builder = Swagger::Builder.new(
      title: "La Spatule",
      version: Laspatule::VERSION,
      description: "La spatule's API",
    )

    builder.add(
      Swagger::Object.new(
        "Ingredient",
        "object",
        [
          Swagger::Property.new("id", "integer", "int32", example: 1),
          Swagger::Property.new("name", example: "aubergine"),
        ],
      )
    )

    builder.add(
      Swagger::Object.new(
        "CreateIngredient",
        "object",
        [Swagger::Property.new("name", example: "aubergine")],
      )
    )

    builder.add(
      Swagger::Controller.new(
        "Ingredients",
        "Manage ingredients",
        [
          Swagger::Action.new(
            "get",
            "/ingredients",
            description: "Get ingredients by name",
            parameters: [
              Swagger::Parameter.new(
                "name",
                "query",
                "string",
                "search query",
                required: true,
              ),
              Swagger::Parameter.new(
                "page_size",
                "query",
                "integer",
                "number of items to return",
                default_value: 20,
              ),
              Swagger::Parameter.new(
                "next_page",
                "query",
                "string",
                "next page's token",
              )
            ],
            responses: [
              Swagger::Response.new("200", "Success", "Ingredient"),
            ],
          ),
          Swagger::Action.new(
            "post",
            "/ingredients",
            description: "Create a new ingredient",
            request: Swagger::Request.new("CreateIngredient"),
            responses: [
              Swagger::Response.new("200", "Success", "Ingredient"),
              Swagger::Response.new("409", "Duplicate")
            ]
          )
        ]
      )
    )

    swagger_api_endpoint = "http://localhost:3000"
    swagger_web_entry_path = "/swagger"
    swagger_api_handler = Swagger::HTTP::APIHandler.new(builder.built, swagger_api_endpoint)
    swagger_web_handler = Swagger::HTTP::WebHandler.new(swagger_web_entry_path, swagger_api_handler.api_url)

    add_handler swagger_api_handler
    add_handler swagger_web_handler
  end
end
