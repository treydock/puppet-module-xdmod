# == Class: xdmod::database
#
# Public class.
#
class xdmod::database (
  $host = 'localhost',
  $port = '3306',
  $user = 'xdmod',
  $password = 'changeme',
) inherits xdmod::params {

  include mysql::server

  Mysql::Db {
    ensure    => 'present',
    user      => $user,
    password  => $password,
    host      => $host,
    charset   => 'utf8',
    collate   => 'utf8_bin',
    grant     => ['ALL'],
  }

  mysql::db { 'mod_hpcdb': }
  mysql::db { 'mod_logger': }
  mysql::db { 'mod_shredder': }
  mysql::db { 'moddb': }
  mysql::db { 'modw': }
  mysql::db { 'modw_aggregates': }

}
