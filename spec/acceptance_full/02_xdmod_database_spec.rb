# frozen_string_literal: true

require 'spec_helper_acceptance_full'

describe 'xdmod class: databases' do
  node = find_only_one(:db)

  context 'when databases only' do
    it 'runs successfully' do
      pp = <<-PP
      class { 'mysql::server':
        root_password    => 'secret',
        override_options => {
          'mysqld' => {
            'bind_address' => '0.0.0.0',
          }
        }
      }->
      class { 'xdmod':
        web                   => false,
        database              => true,
        web_host              => 'web.#{fact('domain')}',
        akrr_host             => 'akrr.#{fact('domain')}',
        database_host         => 'db',
        supremm_mongodb_host  => 'db',
        resources         => [{
          'resource' => 'example',
          'name' => 'Example',
        }],
        supremm_resources => [{
          'resource' => 'example',
          'resource_id' => 1,
          'enabled' => true,
          'datasetmap' => 'pcp',
          'pcp_log_dir' => '/data/pcp-data/example',
        }],
      }
      PP

      apply_manifest_on(node, pp, catch_failures: true)
      # MongoDB password constantly changes on EL6
      if fact('operatingsystemmajrelease') != '6'
        apply_manifest_on(node, pp, catch_changes: true)
      end
    end

    it_behaves_like 'databases', node
  end

  context 'when databases only - all' do
    it 'runs successfully' do
      pp = <<-PP
      class { 'mysql::server':
        root_password    => 'secret',
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
        web_host              => 'web.#{fact('domain')}',
        akrr_host             => 'akrr.#{fact('domain')}',
        database_host         => 'db',
        supremm_mongodb_host  => 'db',
        resources         => [{
          'resource' => 'example',
          'name' => 'Example',
        }],
        supremm_resources => [{
          'resource' => 'example',
          'resource_id' => 1,
          'enabled' => true,
          'datasetmap' => 'pcp',
          'pcp_log_dir' => '/data/pcp-data/example',
        }],
      }
      PP

      apply_manifest_on(node, pp, catch_failures: true)
      # MongoDB password constantly changes on EL6
      if fact('operatingsystemmajrelease') != '6'
        apply_manifest_on(node, pp, catch_changes: true)
      end
    end

    it_behaves_like 'databases', node
  end
end
