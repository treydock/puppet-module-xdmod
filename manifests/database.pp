# == Class: xdmod::database
#
# Public class.
#
class xdmod::database (
  $host     = $xdmod::params::database_host,
  $port     = $xdmod::params::database_port,
  $user     = $xdmod::params::database_user,
  $password = $xdmod::params::database_password,
) inherits xdmod::params {

  include mysql::server

  Mysql::Db {
    ensure    => 'present',
    user      => $user,
    password  => $password,
    host      => $host,
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

}
