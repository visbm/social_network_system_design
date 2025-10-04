Table post_reaction_cache {
  post_id uuid [not null]
  reactions hash [note: 'Reactions for post {[reaction_type: string , amount: int]}']
}