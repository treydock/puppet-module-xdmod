# Private class
class xdmod::supremm::database {

  include epel
  include mongodb::server
  include mongodb::client

  Yumrepo['epel']->Package['mongodb_client']
  Yumrepo['epel']->Package['mongodb_server']

  mongodb::db { 'supremm':
    user     => 'supremm',
    password => $xdmod::supremm_mongodb_password,
    roles    => ['dbAdmin', 'readWrite'],
  }

}