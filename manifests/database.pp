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
    $_modw_filters_sql    = '/usr/share/xdmod/db/schema/modw_filters.sql'
    $_modw_etl_sql        = '/usr/share/xdmod/db/schema/modw_etl.sql'
    $_modw_supremm_sql    = '/usr/share/xdmod/db/schema/modw_supremm.sql'
    $_modw_notify         = undef
  } else {
    $_mod_hpcdb_sql       = undef
    $_mod_logger_sql      = undef
    $_mod_shredder_sql    = undef
    $_moddb_sql           = undef
    $_modw_sql            = undef
    $_modw_aggregates_sql = undef
    $_modw_filters_sql    = undef
    $_modw_etl_sql        = undef
    $_modw_supremm_sql    = undef
    if $xdmod::enable_appkernel {
      $_modw_notify = Exec['create-modw.resourcefact']
    } else {
      $_modw_notify = undef
    }
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
    sql    => $_modw_sql,
    notify => $_modw_notify,
  }
  mysql::db { 'modw_aggregates':
    sql => $_modw_aggregates_sql,
  }
  mysql::db { 'modw_filters':
    sql => $_modw_filters_sql,
  }

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
      #mysql_grant { "${xdmod::akrr_database_user}@${xdmod::akrr_host}/mod_appkernel.*":
      #  ensure     => 'present',
      #  privileges => ['ALL'],
      #  table      => 'mod_appkernel.*',
      #  user       => "${xdmod::akrr_database_user}@${xdmod::akrr_host}",
      #  require    => Mysql::Db['mod_appkernel'],
      #}

      #mysql_grant { "${xdmod::akrr_database_user}@${xdmod::akrr_host}/mod_akrr.*":
      #  ensure     => 'present',
      #  privileges => ['ALL'],
      #  table      => 'mod_akrr.*',
      #  user       => "${xdmod::akrr_database_user}@${xdmod::akrr_host}",
      #  require    => Mysql::Db['mod_akrr'],
      #}
    }

    # Hack to ensure modw.resourcefact exists for mysql_grant
    exec { 'create-modw.resourcefact':
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      command => "mysql modw -e \"CREATE TABLE resourcefact (id int(11) NOT NULL COMMENT 'The id of the resource record')\"",
      unless  => [
        "mysql -BN modw -e 'SHOW TABLES' | egrep -q '^resourcefact$'",
        "mysql -BN mysql -e \"SELECT * FROM tables_priv WHERE User='${xdmod::akrr_database_user}' AND Host='${xdmod::akrr_host}' AND Table_name='resourcefact' AND Table_priv='Select'\" | grep -q 'resourcefact'"
      ],
      require => Mysql::Db['modw'],
      before  => Mysql_grant["${xdmod::akrr_database_user}@${xdmod::akrr_host}/modw.resourcefact"],
      notify  => Exec['drop-modw.resourcefact'],
    }
    exec { 'drop-modw.resourcefact':
      path        => '/usr/bin:/bin:/usr/sbin:/sbin',
      command     => "mysql modw -e \"DROP TABLE resourcefact\"",
      onlyif      => "mysql -BN modw -e 'SHOW TABLES' | egrep -q '^resourcefact$'",
      unless      => "mysql -BN modw -e 'SHOW TABLES' | egrep -q '^account$'",
      refreshonly => true,
      require     => Mysql_grant["${xdmod::akrr_database_user}@${xdmod::akrr_host}/modw.resourcefact"],
    }

    mysql_grant { "${xdmod::akrr_database_user}@${xdmod::akrr_host}/modw.resourcefact":
      ensure     => 'present',
      privileges => ['SELECT'],
      table      => 'modw.resourcefact',
      user       => "${xdmod::akrr_database_user}@${xdmod::akrr_host}",
      require    => [Mysql::Db['modw'], Mysql::Db['mod_akrr']],
    }
  }

  if $xdmod::enable_supremm {
    mysql::db { 'modw_etl':
      sql => $_modw_etl_sql,
    }
    mysql::db { 'modw_supremm':
      sql => $_modw_supremm_sql,
    }
  }

}
