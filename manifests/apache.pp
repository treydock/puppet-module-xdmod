# Private class
class xdmod::apache {

  if $xdmod::manage_apache_vhost {
    include ::apache

    ::apache::vhost { 'xdmod':
      servername     => $xdmod::apache_vhost_name,
      port           => $xdmod::apache_port,
      docroot        => '/usr/share/xdmod/html',
      options        => ['FollowSymLinks'],
      override       => ['All'],
      directoryindex => 'index.php',
      manage_docroot => false,
    }
  }

}
