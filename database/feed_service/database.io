// Replication:
// - master-slave (async)
// - replication factor 2
//
// Sharding:
// - key based by user_id

Table feed {
  id uuid [primary key]
  user_id uuid [not null, note: 'User who will see this post in feed']
  post_id uuid [not null, note: 'Post to show in feed']
  created_at timestamp [note: 'Timestamp when the post was added to feed']
}