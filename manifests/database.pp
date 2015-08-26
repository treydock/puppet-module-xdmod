# Private class
class xdmod::database {

  include mysql::server

  Mysql::Db {
    ensure    => 'present',
    user      => $xdmod::database_user,
    password  => $xdmod::database_password,
    host      => $xdmod::web_host,
    charset   => 'utf8',
    collate   => 'utf8_general_ci',
    grant     => ['ALL'],
  }

  mysql::db { 'mod_hpcdb': }
  mysql::db { 'mod_logger': }
  mysql::db { 'mod_shredder': }
  mysql::db { 'moddb': }
  mysql::db { 'modw': }
  mysql::db { 'modw_aggregates': }

  if $xdmod::enable_appkernel {
    mysql::db { 'mod_appkernel':
      user     => $xdmod::akrr_database_user,
      password => $xdmod::akrr_database_password,
    }

    mysql::db { 'mod_akrr':
      user     => $xdmod::akrr_database_user,
      password => $xdmod::akrr_database_password,
    }

    mysql_grant { "${xdmod::akrr_database_user}@${xdmod::web_host}/modw.resourcefact":
      ensure     => 'present',
      privileges => ['SELECT'],
      table      => 'modw.resourcefact',
      user       => "${xdmod::akrr_database_user}@${xdmod::web_host}",
      require    => Mysql::Db['mod_akrr'],
    }
  }

}
