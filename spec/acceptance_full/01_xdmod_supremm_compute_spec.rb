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
        web_host              => '#{@web_ip}',
        akrr_host             => '#{@akrr_ip}',
        database_host         => '#{@db_ip}',
        supremm_mongodb_host  => '#{@db_ip}',
        supremm_package_url   => 'http://yum.tamu.edu/xdmod/supremm-0.9.0-1.el#{fact('operatingsystemmajrelease')}.x86_64.rpm',
        pcp_log_base_dir      => '/opt/supremm/pmlogger',
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
