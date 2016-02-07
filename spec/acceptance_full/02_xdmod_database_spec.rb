require 'spec_helper_acceptance_full'

describe 'xdmod class: databases' do
  node = find_only_one(:db)

  context 'databases only' do
    it 'should run successfully' do
      pp =<<-EOS
      class { 'mysql::server':
        override_options => {
          'mysqld' => {
            'bind_address' => '0.0.0.0',
          }
        }
      }->
      class { 'mongodb::server':
        bind_ip => [
          '127.0.0.1',
          $::ipaddress,
        ]
      }->
      class { 'xdmod':
        web                   => false,
        database              => true,
        supremm_database      => true,
        enable_appkernel      => true,
        enable_supremm        => true,
        web_host              => 'web',
        akrr_host             => 'akrr',
        database_host         => 'db',
        supremm_mongodb_host  => 'db',
        supremm_package_url   => 'http://yum.tamu.edu/xdmod/supremm-0.9.0-1.el#{fact('operatingsystemmajrelease')}.x86_64.rpm',
        pcp_log_base_dir      => '/opt/supremm/pmlogger',
      }
      EOS

      apply_manifest_on(node, pp, :catch_failures => true)
      # MongoDB password constantly changes on EL6
      if fact('operatingsystemmajrelease') != '6'
        apply_manifest_on(node, pp, :catch_changes => true)
      end
    end

    it_behaves_like 'databases', node
  end
end
