# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'xdmod class:' do
  context 'with compute only enabled' do
    it 'runs successfully' do
      pp = <<-PP
      class { 'xdmod':
        web               => false,
        database          => false,
        compute           => true,
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
        pcp_resource      => 'example',
      }
      PP

      apply_manifest(pp, catch_failures: true)
      # Sleep for a bit to allow pmlogger to start
      sleep(10)
      # The proc pmda is not idempotent and may be bug in PCP module
      if fact('os.release.major').to_s != '8'
        apply_manifest(pp, catch_changes: true)
      end
    end

    it_behaves_like 'compute', default
  end
end
