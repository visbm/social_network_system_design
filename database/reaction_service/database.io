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

Table post_reaction {
  id uuid [primary key,  note: 'Unique identifier of the reaction record']
  post_id uuid [not null, note: 'Post which received the reaction']
  reaction_type varchar(20) [not null, note: 'Type of reaction (like, dislike, heart, laugh, etc.)']
  amount int [note: 'Amount of reactions']

  indexes {
    (post_id, reaction_type) [unique]
  }
}