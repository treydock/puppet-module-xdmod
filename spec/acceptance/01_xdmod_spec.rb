require 'spec_helper_acceptance'

describe 'xdmod class:' do
  context 'default parameters' do
    it 'runs successfully' do
      pp = <<-EOS
      host { 'xdmod.localdomain': ip => '127.0.0.1' }
      if versioncmp($facts['os']['release']['major'], '8') >= 0 {
        $gen_certs = [
          'sscg -q',
          '--cert-file /etc/pki/tls/certs/localhost.crt',
          '--cert-key-file /etc/pki/tls/private/localhost.key',
          '--ca-file /etc/pki/tls/certs/localhost.crt',
          '--lifetime 365',
          "--hostname ${facts['networking']['fqdn']}",
          "--email root@${facts['networking']['fqdn']}",
        ]
        exec { 'httpd-ssl-gencerts':
          command => join($gen_certs, ' '),
          path    => '/usr/bin:/usr/sbin:/bin/sbin',
          creates => '/etc/pki/tls/certs/localhost.crt',
          before  => Apache::Vhost::Custom['xdmod'],
          require => Class['apache'],
        }
      }
      class { 'mysql::server':
        root_password => 'secret',
      }
      class { 'xdmod':
        apache_vhost_name => 'xdmod.localdomain',
        resources         => [{
          'resource' => 'example',
          'name' => 'Example',
        }],
        manage_simplesamlphp => true,
        php_timezone => 'America/New_York',
        enable_ondemand => true,
      }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    it_behaves_like 'xdmod-default', default
  end
end
