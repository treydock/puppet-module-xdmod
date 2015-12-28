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

  if $xdmod::database_host == 'localhost' {
    $_mod_hpcdb_sql       = ['/usr/share/xdmod/db/schema/mod_hpcdb.sql', '/usr/share/xdmod/db/data/mod_hpcdb.sql']
    $_mod_logger_sql      = ['/usr/share/xdmod/db/schema/mod_logger.sql', '/usr/share/xdmod/db/data/mod_logger.sql']
    $_mod_shredder_sql    = ['/usr/share/xdmod/db/schema/mod_shredder.sql', '/usr/share/xdmod/db/data/mod_shredder.sql']
    $_moddb_sql           = ['/usr/share/xdmod/db/schema/moddb.sql', '/usr/share/xdmod/db/data/moddb.sql']
    $_modw_sql            = ['/usr/share/xdmod/db/schema/modw.sql', '/usr/share/xdmod/db/data/modw.sql']
    $_modw_aggregates_sql = '/usr/share/xdmod/db/schema/modw_aggregates.sql'
    $_modw_etl_sql        = '/usr/share/xdmod/db/schema/modw_etl.sql'
    $_modw_supremm_sql    = '/usr/share/xdmod/db/schema/modw_supremm.sql'
  } else {
    $_mod_hpcdb_sql       = undef
    $_mod_logger_sql      = undef
    $_mod_shredder_sql    = undef
    $_moddb_sql           = undef
    $_modw_sql            = undef
    $_modw_aggregates_sql = undef
  }

  mysql::db { 'mod_hpcdb':
    sql => $_mod_hpcdb_sql,
  }
  mysql::db { 'mod_logger':
    sql => $_mod_logger_sql,
  }
  mysql::db { 'mod_shredder':
    sql => $_mod_shredder_sql,
  }
  mysql::db { 'moddb':
    sql => $_moddb_sql,
  }
  mysql::db { 'modw':
    sql => $_modw_sql,
  }
  mysql::db { 'modw_aggregates':
    sql => $_modw_aggregates_sql,
  }

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
      require    => [Mysql::Db['modw'], Mysql::Db['mod_akrr']],
    }
  }

  if $xdmod::enable_supremm {
    mysql::db { 'mod_etl':
      sql => $_modw_etl_sql,
    }
    mysql::db { 'modw_supremm':
      sql => $_modw_supremm_sql,
    }
  }

}
