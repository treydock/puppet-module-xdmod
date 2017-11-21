require 'spec_helper_acceptance_full'

describe 'xdmod class: compute' do
  node = find_only_one(:compute)

  context 'compute only enabled' do
    it 'should run successfully' do
      pp =<<-EOS
      class { 'xdmod':
        web                   => false,
        database              => false,
        compute               => true,
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
        pcp_resource          => 'example',
      }
      EOS

      apply_manifest_on(node, pp, :catch_failures => true)
      # Sleep for a bit to allow pmlogger to start
      sleep(10)
      apply_manifest_on(node, pp, :catch_changes => true)
    end

    it_behaves_like 'compute', node
  end
end
