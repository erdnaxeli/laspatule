# Represents a page of `T` elements, when doing a query with pagination.
#
# To get the first page, the query must be done without *next_page* token.
# To get the next page, the token *next_page* must be provided to the query.
# Each page provide a *next_page* token that must be used to get the following
# page.
record(
  Laspatule::Repositories::Page(T),
  content : Array(T),
  next_page : Int32,
)
