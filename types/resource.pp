type Xdmod::Resource = Struct[{
  resource => String,
  name => String,
  Optional[description] => String,
  Optional[resource_type] => String,
  Optional[pi_column] => String,
  Optional[timezone] => String,
  Optional[shared_jobs] => Boolean,
  Optional[shred_directory] => Stdlib::Absolutepath,
  Optional[hostname] => Stdlib::HTTPSUrl,
}]
