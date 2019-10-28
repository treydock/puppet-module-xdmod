# @summary Manage XDMoD SUPReMM configs
# @api private
class xdmod::supremm::config {

  $modw_supremm_sql = '/usr/lib64/python2.7/site-packages/supremm/assets/modw_supremm.sql'
  $mongo_setup = '/usr/lib64/python2.7/site-packages/supremm/assets/mongo_setup.js'

  exec { 'update-modw_supremm':
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    command => "mysql ${::xdmod::_mysql_remote_args} -D modw_supremm < ${modw_supremm_sql}",
    onlyif  => "mysql -BN ${::xdmod::_mysql_remote_args} -e 'SHOW DATABASES' | egrep -q '^modw_supremm$'",
    unless  => "mysql -BN ${::xdmod::_mysql_remote_args} -e 'SELECT DISTINCT table_name FROM information_schema.columns WHERE table_schema=\"modw_supremm\"' | egrep -q '^archive_paths$'", # lint:ignore:140chars
    require => Package['mysql_client'],
  }

  exec { 'mongodb-supremm-schema':
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    command => "mongo ${::xdmod::supremm_mongo_args} ${mongo_setup}",
    onlyif  => "test `mongo --quiet ${::xdmod::supremm_mongo_args} --eval 'db.schema.count()'` -eq 0",
    require => Package['mongodb_client'],
  }

  if $::xdmod::supremm_mysql_access == 'defaultsfile' {
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

  file { '/etc/supremm/config.json':
    ensure    => 'file',
    owner     => 'root',
    group     => 'root',
    mode      => '0640',
    content   => template('xdmod/supremm/config.json.erb'),
    show_diff => false,
  }

  # Determine if job scripts are to be ingested
  $resources_with_script_dir = $::xdmod::supremm_resources.filter |$r| {
    has_key($r, 'script_dir')
  }
  if empty($resources_with_script_dir) {
    $ingest_jobscripts = false
  } else {
    $ingest_jobscripts = true
  }
  file { '/etc/cron.d/supremm':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('xdmod/supremm/cron.erb'),
  }

}
