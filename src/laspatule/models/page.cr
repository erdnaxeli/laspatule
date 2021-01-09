# Represents a page of `T` elements, when doing a query with pagination.
#
# To get the first page, the query must be done without *next_page* token.
# To get the following page, the token *next_page* from the current page must be
# provided to the query.
#
# If *next_page* if empty it means the current page is the last one.
#
# *next_page* should be considered to be opaque token.
record(
  Laspatule::Models::Page(T),
  content : Array(T),
  next_page : String?,
)
