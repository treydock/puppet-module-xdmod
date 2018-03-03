require 'spec_helper_acceptance_full'

describe 'xdmod class: akrr' do
  node = find_only_one(:akrr)

  context 'akrr only' do
    it 'should run successfully' do
      pp =<<-EOS
      class { 'xdmod':
        web                   => false,
        database              => false,
        akrr                  => true,
        enable_appkernel      => true,
        enable_supremm        => true,
        apache_vhost_name     => 'xdmod.localdomain',
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
      EOS

      apply_manifest_on(node, pp, :catch_failures => true)
      apply_manifest_on(node, pp, :catch_changes => true)
    end

    it_behaves_like 'akrr', node
  end
end
