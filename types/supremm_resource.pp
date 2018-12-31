type Xdmod::Supremm_Resource = Struct[{
  resource => String,
  resource_id => Integer,
  Optional[enabled] => Boolean,
  Optional[datasetmap] => String,
  Optional[datasetmap_source] => String,
  Optional[hardware] => Struct[{gpfs => String}],
  Optional[hostname_mode] => Enum['fqdn','hostname'],
  Optional[pcp_log_dir] => Stdlib::Unixpath,
  Optional[script_dir] => Stdlib::Unixpath,
  Optional[fast_index] => Boolean,
  Optional[timezone] => String,
}]
