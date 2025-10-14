// Replication:
// - replication factor 2
//
// Sharding:
// - key based by etag
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