require 'spec_helper_acceptance_full'

describe 'xdmod class: web' do
  node = find_only_one(:web)

  context 'web only' do
    it 'should run successfully' do
      pp =<<-EOS
      class { 'xdmod':
        web                   => true,
        database              => false,
        apache_vhost_name     => 'xdmod.localdomain',
        web_host              => 'web.#{fact('domain')}',
        akrr_host             => 'akrr.#{fact('domain')}',
        database_host         => 'db',
        supremm_mongodb_host  => 'db',
        resources             => [{
          'resource' => 'example',
          'name' => 'Example',
          'resource_id' => 1,
          'pcp_log_dir' => '/data/pcp-data/example',
        }],
      }
      EOS

      apply_manifest_on(node, pp, :catch_failures => true)
      apply_manifest_on(node, pp, :catch_changes => true)
    end

    it_behaves_like 'xdmod-default', node
  end

  context 'web only - all' do
    it 'should run successfully' do
      pp =<<-EOS
      class { 'xdmod':
        web                   => true,
        database              => false,
        enable_appkernel      => true,
        enable_supremm        => true,
        apache_vhost_name     => 'xdmod.localdomain',
        web_host              => 'web.#{fact('domain')}',
        akrr_host             => 'akrr.#{fact('domain')}',
        database_host         => 'db',
        supremm_mongodb_host  => 'db',
        resources             => [{
          'resource' => 'example',
          'name' => 'Example',
          'resource_id' => 1,
          'pcp_log_dir' => '/data/pcp-data/example',
        }],
      }
      EOS

      apply_manifest_on(node, pp, :catch_failures => true)
      apply_manifest_on(node, pp, :catch_changes => true)
    end

    it_behaves_like 'xdmod-full', node
  end
end
