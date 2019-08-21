require 'spec_helper_acceptance'

describe 'xdmod class:' do
  context 'supremm enabled' do
    it 'runs successfully' do
      pp_clean = "class { 'pcp': ensure => 'absent' }"
      pp = <<-EOS
      host { 'xdmod.localdomain': ip => '127.0.0.1' }
      class { 'mysql::server':
        root_password => 'secret',
      }
      class { 'xdmod':
        supremm             => true,
        enable_supremm      => true,
        apache_vhost_name   => 'xdmod.localdomain',
        supremm_database    => true,
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
        manage_simplesamlphp => true,
        php_timezone => 'America/New_York',
      }
      EOS

      apply_manifest(pp_clean, catch_failures: true)
      apply_manifest(pp, catch_failures: true)
      # MongoDB password constantly changes on EL6
      if fact('operatingsystemmajrelease') != '6'
        apply_manifest(pp, catch_changes: true)
      end
    end

    it_behaves_like 'xdmod-supremm', default
  end
end
