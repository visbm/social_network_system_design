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