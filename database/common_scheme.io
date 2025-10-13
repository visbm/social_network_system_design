Table post {
  id uuid [primary key, note: 'Unique identifier of the post']
  user_id uuid [not null, note: 'Identifier of the user who created the post']
  description text(100) [note: 'Content of the post']
  location varchar [note: 'Location related to the post (coordinates)']
  tags varchar[] [note: 'Array of tags']
  photo_urls varchar[] [note: 'Array of photo URLs attached to the post']
  created_at timestamp [note: 'Timestamp when the post was created']
  updated_at timestamp [note: 'Timestamp when the post was last updated']
  deleted_at timestamp [note: 'Timestamp when the post was deleted (soft delete)']

  indexes {
    (id, user_id, location) [unique]
  }
}

Table post_reaction_cache {
  post_id uuid [not null]
  reactions hash [note: 'Reactions for post {[reaction_type: string , amount: int]}']
}

Table reaction {
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

Table reaction_post {
  id uuid [primary key,  note: 'Unique identifier of the reaction record']
  post_id uuid [not null, note: 'Post which received the reaction']
  reaction_type varchar(20) [not null, note: 'Type of reaction (like, dislike, heart, laugh, etc.)']
  amount int [note: 'Amount of reactions']

  indexes {
    (post_id, reaction_type) [unique]
  }
}

Table comment {
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

Table feed {
  id uuid [primary key]
  user_id uuid [not null, note: 'User who will see this post in feed']
  post_id uuid [not null, note: 'Post to show in feed']
  created_at timestamp [note: 'Timestamp when the post was added to feed']
}


Table feed_caсhe_user_subscription {
  subscribed_to_id uuid [not null, note: 'User who is being followed']
  subscriber_id uuid[] [not null, note: 'User who subscribes']
}

Table object_storage {
  id uuid [pk, not null, note: 'Unique identifier of the stored object']
  bucket varchar [not null, note: 'Logical storage namespace (bucket)']
  object_key varchar [not null, note: 'Unique object key, e.g. user/123/photo.jpg']
  size bigint [not null, note: 'Size of the object in bytes']
  content_type varchar [note: 'MIME type of the object, e.g. image/jpeg']
  etag varchar [note: 'Content hash or version identifier']
  data blob [not null, note: 'Raw binary content of the object']
  created_at timestamp [not null, note: 'Timestamp when the object was uploaded']
}

Table post_search {
  post_id uuid [primary key, note: 'Unique identifier of the post']
  body object [note: 'Full request payload stored']
  tags keyword[] [note: 'Array of tags for filtering/search']
  location geo_point [note: 'Geo location for distance-based search']
}