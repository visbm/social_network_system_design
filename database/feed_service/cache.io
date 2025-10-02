Table feed_caсhe_user_subscription {
  subscribed_to_id uuid [not null, note: 'User who is being followed']
  subscriber_id uuid[] [not null, note: 'User who subscribes']
}