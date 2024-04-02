# @summary Manage XDMoD SUPReMM configs
# @api private
class xdmod::supremm::config {
  $mysql_remote_args = $xdmod::_mysql_remote_args
  $modw_supremm_sql = '/usr/lib64/python3.6/site-packages/supremm/assets/modw_supremm.sql'
  $mongo_setup = '/usr/lib64/python3.6/site-packages/supremm/assets/mongo_setup.js'

  exec { 'update-modw_supremm':
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    command => "mysql ${mysql_remote_args} -D modw_supremm < ${modw_supremm_sql}",
    onlyif  => "mysql -BN ${mysql_remote_args} -e 'SHOW DATABASES' | egrep -q '^modw_supremm$'",
    unless  => "mysql -BN ${mysql_remote_args} -e 'SELECT DISTINCT table_name FROM information_schema.columns WHERE table_schema=\"modw_supremm\"' | egrep -q '^archive_paths$'", # lint:ignore:140chars
    require => Package['mysql_client'],
  }

  exec { 'mongodb-supremm-schema':
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    command => "mongo ${xdmod::supremm_mongo_args} ${mongo_setup}",
    onlyif  => "test `mongo --quiet ${xdmod::supremm_mongo_args} --eval 'db.schema.count()'` -eq 0",
    require => Package['mongodb_client'],
  }

  exec { 'mongodb-supremm-schema-refresh':
    path        => '/usr/bin:/bin:/usr/sbin:/sbin',
    command     => "mongo ${xdmod::supremm_mongo_args} ${mongo_setup}",
    onlyif      => "test `mongo --quiet ${xdmod::supremm_mongo_args} --eval 'db.schema.count()'` -gt 0",
    refreshonly => true,
    require     => Package['mongodb_client'],
    subscribe   => Class['xdmod::supremm::install'],
  }

  if $xdmod::supremm_mysql_access == 'defaultsfile' {
    $_defaults_file_ensure = 'file'
  } else {
    $_defaults_file_ensure = 'absent'
  }

  file { '/root/.supremm.my.cnf':
    ensure    => $_defaults_file_ensure,
    owner     => 'root',
    group     => 'root',
    mode      => '0600',
    content   => template('xdmod/supremm/supremm.my.cnf.erb'),
    show_diff => false,
  }
  file { '/var/lib/xdmod/.supremm.my.cnf':
    ensure    => $_defaults_file_ensure,
    owner     => 'root',
    group     => 'root',
    mode      => '0600',
    content   => template('xdmod/supremm/supremm.my.cnf.erb'),
    show_diff => false,
  }

  file { '/etc/supremm/config.json':
    ensure    => 'file',
    owner     => 'root',
    group     => 'xdmod',
    mode      => '0640',
    content   => template('xdmod/supremm/config.json.erb'),
    show_diff => false,
  }

  $prometheus_mapping = deep_merge($xdmod::params::prometheus_mapping, $xdmod::supremm_prometheus_mapping)
  file { '/etc/supremm/mapping.json':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => to_json_pretty($prometheus_mapping),
  }
}
