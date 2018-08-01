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

  if $xdmod::enable_appkernel {
    $_modw_notify = Exec['create-modw.resourcefact']
  } else {
    $_modw_notify = undef
  }

  mysql::db { 'mod_hpcdb': }
  mysql::db { 'mod_logger': }
  mysql::db { 'mod_shredder': }
  mysql::db { 'moddb': }
  mysql::db { 'modw':
    notify => $_modw_notify,
  }
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
      command => "mysql --defaults-file=/root/.my.cnf modw -e \"CREATE TABLE resourcefact (id int(11) NOT NULL COMMENT 'The id of the resource record')\"",
      unless  => "mysql --defaults-file=/root/.my.cnf -BN modw -e 'SHOW TABLES' | egrep -q '^resourcefact$'",
      require => Mysql::Db['modw'],
      before  => Mysql_grant["${xdmod::akrr_database_user}@${xdmod::akrr_host}/modw.resourcefact"],
      notify  => Exec['drop-modw.resourcefact'],
    }
    exec { 'drop-modw.resourcefact':
      path        => '/usr/bin:/bin:/usr/sbin:/sbin',
      command     => "mysql --defaults-file=/root/.my.cnf modw -e \"DROP TABLE resourcefact\"",
      onlyif      => "mysql --defaults-file=/root/.my.cnf -BN modw -e 'SHOW TABLES' | egrep -q '^resourcefact$'",
      unless      => "mysql --defaults-file=/root/.my.cnf -BN modw -e 'SHOW TABLES' | egrep -q '^account$'",
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
    mysql::db { 'modw_etl': }
    mysql::db { 'modw_supremm': }
  }

}
