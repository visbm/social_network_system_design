Table post {
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