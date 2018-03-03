type Xdmod::Supremm_Resource = Struct[{
  resource => String,
  resource_id => Integer,
  Optional[enabled] => Boolean,
  Optional[datasetmap] => Enum['pcp'],
  Optional[hardware] => Struct[{gpfs => String}],
  Optional[pcp_log_dir] => Stdlib::Unixpath,
  Optional[script_dir] => Stdlib::Unixpath,
}]
