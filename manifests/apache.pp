# Private class
class xdmod::apache {

  if $xdmod::manage_apache_vhost {
    include ::apache

    if $xdmod::apache_ssl {
      $xdmod_ssl_rewrites = [
        {
          comment      => 'Redirect to HTTPS if not localhost',
          rewrite_cond => ['%{REMOTE_ADDR} !=127.0.0.1', '%{REMOTE_ADDR} !=::1'],
          rewrite_rule => ['^/?(.*) https://%{SERVER_NAME}/$1 [R,L]'],
        },
      ]
      $xdmod_nonssl_order = 'deny,allow'
      $xdmod_nonssl_deny  = 'from all'
      $xdmod_nonssl_allow = 'from 127.0.0.0/255.0.0.0 ::1/128'

      ::apache::vhost { 'xdmod_ssl':
        servername     => $xdmod::apache_vhost_name,
        port           => $xdmod::apache_ssl_port,
        ssl            => true,
        docroot        => '/usr/share/xdmod/html',
        manage_docroot => false,
        ssl_cert       => $xdmod::apache_ssl_cert,
        ssl_key        => $xdmod::apache_ssl_key,
        ssl_chain      => $xdmod::apache_ssl_chain,
        directories    => [
          {
            path           => '/usr/share/xdmod/html',
            options        => ['FollowSymLinks'],
            override       => ['All'],
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
                rewrite_rule => ['(.*) index.php [L]']
              }
            ],
          },
        ]
      }
    } else {
      $xdmod_ssl_rewrites = undef
      $xdmod_nonssl_order = 'allow,deny'
      $xdmod_nonssl_deny  = undef
      $xdmod_nonssl_allow = 'from all'
    }

    ::apache::vhost { 'xdmod':
      servername     => $xdmod::apache_vhost_name,
      port           => $xdmod::apache_port,
      ssl            => false,
      docroot        => '/usr/share/xdmod/html',
      manage_docroot => false,
      rewrites       => $xdmod_ssl_rewrites,
      directories    => [
        {
          path           => '/usr/share/xdmod/html',
          options        => ['FollowSymLinks'],
          allow_override => ['All'],
          directoryindex => 'index.php',
          order          => $xdmod_nonssl_order,
          deny           => $xdmod_nonssl_deny,
          allow          => $xdmod_nonssl_allow,
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
              rewrite_rule => ['(.*) index.php [L]']
            }
          ],
        },
      ]
    }

  }

}
