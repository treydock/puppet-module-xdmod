# Private class
class xdmod::apache {

  if $xdmod::manage_apache_vhost {
    include ::apache

    $_default_directories = [
      {
        path           => '/usr/share/xdmod/html',
        options        => ['FollowSymLinks'],
        allow_override => ['All'],
        directoryindex => 'index.php',
      },
      {
        path     => '/usr/share/xdmod/html/rest',
        rewrites => [
          {
            rewrite_rule => ['(.*) index.php [L]'],
          }
        ],
      },
      {
        path     => '/usr/share/xdmod/html/extrest',
        rewrites => [
          {
            rewrite_rule => ['(.*) index.php [L]'],
          }
        ]
      },
    ]

    if $xdmod::apache_ssl {
      $_redirect_status   = 'permanent'
      $_redirect_dest     = "https://${xdmod::apache_vhost_name}:${xdmod::apache_ssl_port}/"
      $_http_directories  = undef

      ::apache::vhost { 'xdmod_ssl':
        servername     => $xdmod::apache_vhost_name,
        port           => $xdmod::apache_ssl_port,
        ssl            => true,
        docroot        => '/usr/share/xdmod/html',
        manage_docroot => false,
        ssl_cert       => $xdmod::apache_ssl_cert,
        ssl_key        => $xdmod::apache_ssl_key,
        ssl_chain      => $xdmod::apache_ssl_chain,
        directories    => $_default_directories,
      }
    } else {
      $_redirect_status   = undef
      $_redirect_dest     = undef
      $_http_directories  = $_default_directories
    }

    ::apache::vhost { 'xdmod':
      servername      => $xdmod::apache_vhost_name,
      port            => $xdmod::apache_port,
      docroot         => '/usr/share/xdmod/html',
      manage_docroot  => false,
      redirect_status => $_redirect_status,
      redirect_dest   => $_redirect_dest,
      directories     => $_http_directories,
    }
  }

}
