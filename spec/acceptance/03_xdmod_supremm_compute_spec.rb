require 'spec_helper_acceptance'

describe 'xdmod class:' do
  context 'compute only enabled' do
    it 'should run successfully' do
      pp =<<-EOS
      class { 'xdmod':
        web               => false,
        database          => false,
        compute           => true,
        pcp_log_base_dir  => '/opt/supremm/pmlogger',
      }
      EOS

      apply_manifest(pp, :catch_failures => true)
      # Sleep for a bit to allow pmlogger to start
      sleep(10)
      apply_manifest(pp, :catch_changes => true)
    end

    it_behaves_like 'compute', default
  end
end
