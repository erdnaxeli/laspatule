require "swagger"
require "swagger/http/handler"

module Laspatule::API::Doc
  def self.setup
    builder = Swagger::Builder.new(
      title: "La Spatule",
      version: Laspatule::VERSION,
      description: "La spatule's API",
      authorizations: [
        Swagger::Authorization.none,
        Swagger::Authorization.new("bearer", "access token"),
      ]
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
        "IngredientsPage",
        "object",
        [
          Swagger::Property.new("content", "array", items: "Ingredient"),
          Swagger::Property.new("next_page", description: "an opaque token to use to get the next page")
        ]
      ),
    )
    builder.add(
      Swagger::Object.new(
        "CreateIngredient",
        "object",
        [Swagger::Property.new("name", example: "aubergine")],
      )
    )
    builder.add(
      Swagger::Object.new(
        "User",
        "object",
        [
          Swagger::Property.new("id", "integer", "int32", example: 1),
          Swagger::Property.new("name", example: "George Abitbol"),
        ]
      )
    )
    builder.add(
      Swagger::Object.new(
        "Login",
        "object",
        [
          Swagger::Property.new("email", example: "george.abitbol@example.org"),
          Swagger::Property.new("password", "string", "password", example: "very secret"),
        ]
      )
    )
    builder.add(
      Swagger::Object.new(
        "Recipe",
        "object",
        [
          Swagger::Property.new("id", "integer", "int32", example: 1),
          Swagger::Property.new("title", example: "La ratatouille"),
          Swagger::Property.new(
            "ingredients",
            "array",
            items: Swagger::Object.new(
              "RecipeIngredient",
              "object",
              [
                Swagger::Property.new("id", "integer", "int32", example: 1),
                Swagger::Property.new("name", example: "Aubergine"),
                Swagger::Property.new("quantity", example: "1"),
              ]
            ),
          ),
          Swagger::Property.new(
            "sections",
            "array",
            items: Swagger::Object.new(
              "RecipeSection",
              "object",
              [
                Swagger::Property.new("id", "integer", "int32", example: 1),
                Swagger::Property.new(
                  "steps",
                  "array",
                  items: Swagger::Object.new(
                    "RecipeStep",
                    "object",
                    [
                      Swagger::Property.new("id", "integer", "int32", example: 1),
                      Swagger::Property.new("instruction", example: "Couper en morceaux"),
                    ]
                  )
                ),
              ]
            )
          ),
          Swagger::Property.new(
            "user",
            "object",
            ref: "User",
          )
        ]
      )
    )
    builder.add(
      Swagger::Object.new(
        "RecipesPage",
        "object",
        [
          Swagger::Property.new("content", "array", items: "Recipe"),
          Swagger::Property.new("next_page", description: "an opaque token to use to get the next page")
        ]
      ),
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
              ),
            ],
            responses: [
              Swagger::Response.new("200", "Success", "IngredientsPage"),
            ],
            authorization: true,
          ),
          Swagger::Action.new(
            "post",
            "/ingredients",
            description: "Create a new ingredient",
            request: Swagger::Request.new("CreateIngredient"),
            responses: [
              Swagger::Response.new("200", "Success", "Ingredient"),
              Swagger::Response.new("409", "Duplicate"),
            ],
            authorization: true
          ),
        ]
      )
    )

    builder.add(
      Swagger::Controller.new(
        "User",
        "Manage user",
        [
          Swagger::Action.new(
            "get",
            "/user",
            description: "Return the current user",
            responses: [
              Swagger::Response.new("200", "Success", "User"),
              Swagger::Response.new("401", "Authorization required"),
            ],
            authorization: true,
          ),
          Swagger::Action.new(
            "post",
            "/user/auth",
            description: "Auth an user and get an access token",
            request: Swagger::Request.new("Login"),
            responses: [
              Swagger::Response.new(
                "200",
                "Success",
                Swagger::Objects::Schema.new("string")
              ),
              Swagger::Response.new("401", "Authorization required"),
            ]
          ),
        ]
      ),
    )

    builder.add(
      Swagger::Controller.new(
        "Recipes",
        "Manage recipes",
        [
          Swagger::Action.new(
            "get",
            "/recipes",
            description: "Get recipes",
            responses: [
              Swagger::Response.new("200", "Success", "RecipesPage"),
            ]
          ),
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
