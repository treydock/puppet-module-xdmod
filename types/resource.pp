type Xdmod::Resource = Struct[{
  resource => String,
  resource_id => Integer,
  name => String,
  pi_column => Optional[String],
  pcp_log_dir => Optional[Stdlib::Unixpath],
  script_dir => Optional[Stdlib::Unixpath],
}]
