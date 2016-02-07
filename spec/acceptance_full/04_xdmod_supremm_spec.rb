require 'spec_helper_acceptance_full'

describe 'xdmod class: supremm' do
  node = find_only_one(:supremm)

  context 'supremm only' do
    it 'should run successfully' do
      pp =<<-EOS
      class { 'xdmod':
        web                   => false,
        database              => false,
        supremm               => true,
        enable_appkernel      => true,
        enable_supremm        => true,
        supremm_package_url   => 'http://yum.tamu.edu/xdmod/supremm-0.9.0-1.el#{fact('operatingsystemmajrelease')}.x86_64.rpm',
        apache_vhost_name     => 'xdmod.localdomain',
        web_host              => 'web',
        akrr_host             => 'akrr',
        database_host         => 'db',
        supremm_mongodb_host  => 'db',
        pcp_log_base_dir      => '/opt/supremm/pmlogger',
      }
      EOS

      apply_manifest_on(node, pp, :catch_failures => true)
      apply_manifest_on(node, pp, :catch_changes => true)
    end

    it_behaves_like 'supremm', node
  end
end
