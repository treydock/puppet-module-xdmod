# Private class
class xdmod::database {

  include mysql::server

  Mysql::Db {
    ensure    => 'present',
    user      => $xdmod::database_user,
    password  => $xdmod::database_password,
    host      => $xdmod::web_host,
    charset   => 'latin1',
    collate   => 'latin1_swedish_ci',
    grant     => ['ALL'],
  }

  mysql::db { 'mod_hpcdb': }
  mysql::db { 'mod_logger': }
  mysql::db { 'mod_shredder': }
  mysql::db { 'moddb': }
  mysql::db { 'modw': }
  mysql::db { 'modw_aggregates': }
  mysql::db { 'modw_filters': }

  if $xdmod::enable_appkernel {
    mysql::db { 'mod_appkernel':
      user     => $xdmod::akrr_database_user,
      password => $xdmod::akrr_database_password,
      host     => $xdmod::akrr_host,
    }

    mysql::db { 'mod_akrr':
      user     => $xdmod::akrr_database_user,
      password => $xdmod::akrr_database_password,
      host     => $xdmod::akrr_host,
    }

    mysql::db { 'modw-akrr':
      dbname   => 'modw',
      user     => $xdmod::akrr_database_user,
      password => $xdmod::akrr_database_password,
      host     => $xdmod::akrr_host,
      grant    => ['SELECT'],
      require  => Mysql::Db['modw'],
    }

    if $xdmod::web_host != $xdmod::akrr_host {
      mysql::db { 'mod_appkernel-xdmod':
        dbname   => 'mod_appkernel',
        user     => $xdmod::akrr_database_user,
        password => $xdmod::akrr_database_password,
      }

      mysql::db { 'mod_akrr-xdmod':
        dbname   => 'mod_akrr',
        user     => $xdmod::akrr_database_user,
        password => $xdmod::akrr_database_password,
      }
    }
  }

  if $xdmod::enable_supremm {
    mysql::db { 'modw_etl': }
    mysql::db { 'modw_supremm': }
  }

}
