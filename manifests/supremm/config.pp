# Private class
class xdmod::supremm::config {

  exec { 'update-modw_supremm':
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    command => "mysql ${xdmod::_mysql_remote_args} -D modw_supremm < /usr/share/supremm/setup/modw_supremm.sql",
    onlyif  => "mysql -BN ${xdmod::_mysql_remote_args} -e 'SHOW DATABASES' | egrep -q '^modw_supremm$'",
    unless  => "mysql -BN ${xdmod::_mysql_remote_args} -e 'SELECT DISTINCT table_name FROM information_schema.columns WHERE table_schema=\"modw_supremm\"' | egrep -q '^archive$'",
    require => Package['mysql_client'],
  }

  exec { 'mongodb-supremm-schema':
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    command => "mongo ${xdmod::supremm_mongodb_host} /usr/share/supremm/setup/mongo_setup.js",
    onlyif  => "test `mongo --quiet ${xdmod::supremm_mongodb_host}/supremm --eval 'db.schema.count()'` -eq 0",
    require => Package['mongodb_client'],
  }

  if $xdmod::_supremm_mysql_access == 'defaultsfile' {
    $_defaults_file_ensure = 'file'
  } else {
    $_defaults_file_ensure = 'absent'
  }

  file { '/root/.supremm.my.cnf':
    ensure  => $_defaults_file_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('xdmod/supremm/supremm.my.cnf.erb'),
  }

  file { '/etc/supremm/config.json':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('xdmod/supremm/config.json.erb'),
  }

}