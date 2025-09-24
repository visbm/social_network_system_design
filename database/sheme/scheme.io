// Use DBML to define your database structure
// Docs: https://dbml.dbdiagram.io/docs


Table posts {
  id integer [primary key, note: 'Unique identifier of the post']
  user_id integer [not null, note: 'Identifier of the user who created the post']
  description text [note: 'Content of the post']
  location varchar [note: 'Location related to the post']
  photo_urls varchar[] [note: 'Array of photo URLs attached to the post']
  created_at timestamp [note: 'Timestamp when the post was created']
  updated_at timestamp [note: 'Timestamp when the post was last updated']
  deleted_at timestamp [note: 'Timestamp when the post was deleted (soft delete)']
}

Table comments {
  id integer [primary key, note: 'Unique identifier of the comment']
  post_id integer [not null, note: 'Identifier of the post the comment belongs to']
  user_id integer [not null, note: 'Identifier of the user who wrote the comment']
  text varchar(250) [not null, note: 'Content of the comment']
  created_at timestamp [note: 'Timestamp when the comment was created']
  updated_at timestamp [note: 'Timestamp when the comment was last updated']
  deleted_at timestamp [note: 'Timestamp when the comment was deleted (soft delete)']
}

Table user_subscriptions {
  subscriber_id integer [not null, note: 'User who subscribes']
  subscribed_to_id integer [not null, note: 'User who is being followed']
  created_at timestamp [note: 'Timestamp when the subscription was created']
}

Table post_reactions {
  id integer [primary key, note: 'Unique identifier of the reaction record']
  post_id integer [not null, note: 'Post which received the reaction']
  user_id integer [not null, note: 'User who reacted']
  reaction_type varchar(20) [not null, note: 'Type of reaction (like, dislike, heart, laugh, etc.)']
  created_at timestamp [note: 'Timestamp when the reaction was created']
}

Table feed_posts {
  id integer [primary key]
  user_id integer [not null, note: 'User who will see this post in feed']
  post_id integer [not null, note: 'Post to show in feed']
  created_at timestamp
}


Ref: feed_posts.post_id > posts.id
Ref: post_reactions.post_id > posts.id
Ref posts_comments: posts.id < comments.post_id // many-to-one
