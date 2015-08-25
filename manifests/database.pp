# Private class
class xdmod::database {

  include mysql::server

  Mysql::Db {
    ensure    => 'present',
    user      => $xdmod::database_user,
    password  => $xdmod::database_password,
    host      => $xdmod::web_host_real,
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
    mysql::db { 'mod_appkernel': }
  }

}
