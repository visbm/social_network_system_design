// Replication:
// - master-slave (sync)
// - replication factor 2
//
// Sharding:
// - key based by user_id

Table user_subscription {
  subscriber_id uuid [not null, note: 'User who subscribes']
  subscribed_to_id uuid [not null, note: 'User who is being followed']
  created_at timestamp [note: 'Timestamp when the user_subscriptions was created']
  updated_at timestamp [note: 'Timestamp when the user_subscriptions was last updated']
  deleted_at timestamp [note: 'Timestamp when the user_subscriptions was deleted (soft delete)']

  indexes {
    (subscriber_id, subscribed_to_id) [unique]
  }
}