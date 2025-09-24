Table posts {
  id uuid [primary key, note: 'Unique identifier of the post']
  user_id uuid [not null, note: 'Identifier of the user who created the post']
  description text(100) [note: 'Content of the post']
  location varchar [note: 'Location related to the post (coordinates)']
  photo_urls varchar[] [note: 'Array of photo URLs attached to the post']
  created_at timestamp [note: 'Timestamp when the post was created']
  updated_at timestamp [note: 'Timestamp when the post was last updated']
  deleted_at timestamp [note: 'Timestamp when the post was deleted (soft delete)']

  indexes {
    (id, user_id, location) [unique]
  }
}

Table comments {
  id uuid [primary key, note: 'Unique identifier of the comment']
  post_id uuid [not null, note: 'Identifier of the post the comment belongs to']
  user_id uuid [not null, note: 'Identifier of the user who wrote the comment']
  text varchar(250) [not null, note: 'Content of the comment']
  created_at timestamp [note: 'Timestamp when the comment was created']
  updated_at timestamp [note: 'Timestamp when the comment was last updated']
  deleted_at timestamp [note: 'Timestamp when the comment was deleted (soft delete)']

  indexes {
   (id, user_id, post_id) [unique]
  }
}

Table user_subscriptions {
  subscriber_id uuid [not null, note: 'User who subscribes']
  subscribed_to_id uuid [not null, note: 'User who is being followed']
  created_at timestamp [note: 'Timestamp when the user_subscriptions was created']
  updated_at timestamp [note: 'Timestamp when the user_subscriptions was last updated']
  deleted_at timestamp [note: 'Timestamp when the user_subscriptions was deleted (soft delete)']

  indexes {
    (subscriber_id, subscribed_to_id) [unique]
  }
}

Table post_reactions {
  id uuid [primary key,  note: 'Unique identifier of the reaction record']
  post_id uuid [not null, note: 'Post which received the reaction']
  user_id uuid [not null, note: 'User who reacted']
  reaction_type varchar(20) [not null, note: 'Type of reaction (like, dislike, heart, laugh, etc.)']
  created_at timestamp [note: 'Timestamp when the post_reactions was created']
  updated_at timestamp [note: 'Timestamp when the post_reactions was last updated']
  deleted_at timestamp [note: 'Timestamp when the post_reactions was deleted (soft delete)']

  indexes {
    (post_id, user_id, reaction_type) [unique]
  }
}

Table feed_posts {
  id uuid [primary key]
  user_id uuid [not null, note: 'User who will see this post in feed']
  post_id uuid [not null, note: 'Post to show in feed']
  created_at timestamp [note: 'Timestamp when the post was added to feed']
}

Ref: comments.post_id > posts.id
Ref: post_reactions.post_id > posts.id
Ref: feed_posts.post_id > posts.id
