// DB: Elastic Search
// Replication:
// - replication factor 3

Table post_search {
  post_id uuid [primary key, note: 'Unique identifier of the post']
  body object [note: 'Full request payload stored']
  tags keyword[] [note: 'Array of tags for filtering/search']
  location geo_point [note: 'Geo location for distance-based search']
}
