require 'spec_helper_acceptance'

describe 'xdmod class:' do
  context 'default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
      host { 'xdmod.localdomain': ip => '127.0.0.1' }
      class { 'xdmod':
        apache_vhost_name => 'xdmod.localdomain',
        resources         => [{
          'resource' => 'example',
          'name' => 'Example',
          'resource_id' => 1,
          'pcp_log_dir' => '/data/pcp-data/example',
        }],
      }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    it_behaves_like 'xdmod-default', default
  end

  context 'create_local_repo => false' do
    it 'should require no changes' do
      pp =<<-EOS
      host { 'xdmod.localdomain': ip => '127.0.0.1' }
      class { 'xdmod':
        create_local_repo => false,
        apache_vhost_name => 'xdmod.localdomain',
        resources         => [{
          'resource' => 'example',
          'name' => 'Example',
          'resource_id' => 1,
          'pcp_log_dir' => '/data/pcp-data/example',
        }],
      }
      EOS

      apply_manifest(pp, :catch_changes => true)
    end
  end
end
