require 'spec_helper'

describe 'xdmod' do
  on_supported_os(supported_os: [
                    {
                      'operatingsystem' => 'CentOS',
                      'operatingsystemrelease' => ['7'],
                    },
                  ]).each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('xdmod') }
      it { is_expected.to contain_class('xdmod::params') }

      it { is_expected.to contain_class('xdmod::user').that_comes_before('Class[xdmod::install]') }
      it { is_expected.to contain_class('xdmod::install').that_comes_before('Class[xdmod::database]') }
      it { is_expected.to contain_class('xdmod::database').that_comes_before('Class[xdmod::config]') }
      it { is_expected.to contain_class('xdmod::config').that_comes_before('Class[xdmod::config::simplesamlphp]') }
      it { is_expected.to contain_class('xdmod::config::simplesamlphp').that_comes_before('Class[xdmod::apache]') }
      it { is_expected.to contain_class('xdmod::apache') }

      it_behaves_like 'xdmod::user', facts
      it_behaves_like 'xdmod::install', facts
      it_behaves_like 'xdmod::database', facts
      it_behaves_like 'xdmod::config', facts
      it_behaves_like 'xdmod::config::simplesamlphp', facts
      it_behaves_like 'xdmod::apache', facts

      context 'when akrr => true' do
        let(:params) { { akrr: true } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to compile }
      end

      context 'when supremm => true', if: facts[:os]['release']['major'].to_s == '7' do
        let(:default_params) { { supremm: true, web: true } }
        let(:params) { default_params }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to compile }

        it_behaves_like 'xdmod::supremm::config', facts
      end

      context 'when database => true && supremm_database => true' do
        let(:params) { { database: true, supremm_database: true } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to compile }
      end

      context 'when web => false' do
        let(:params) { { web: false } }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('xdmod::database') }

        it { is_expected.not_to contain_class('xdmod::install') }
        it { is_expected.not_to contain_class('xdmod::config') }

        it_behaves_like 'xdmod::database', facts
      end

      context 'when database => false' do
        let(:params) { { database: false } }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('xdmod::user').that_comes_before('Class[xdmod::install]') }
        it { is_expected.to contain_class('xdmod::install').that_comes_before('Class[xdmod::config]') }
        it { is_expected.to contain_class('xdmod::config').that_comes_before('Class[xdmod::config::simplesamlphp]') }
        it { is_expected.to contain_class('xdmod::config::simplesamlphp').that_comes_before('Class[xdmod::apache]') }
        it { is_expected.to contain_class('xdmod::apache') }

        it { is_expected.not_to contain_class('xdmod::database') }

        it_behaves_like 'xdmod::user', facts
        it_behaves_like 'xdmod::install', facts
        it_behaves_like 'xdmod::config', facts
        it_behaves_like 'xdmod::config::simplesamlphp', facts
        it_behaves_like 'xdmod::apache', facts
      end

      context 'when ondemand enabled' do
        let(:params) { { enable_ondemand: true } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('xdmod::install').that_comes_before('Class[xdmod::ondemand]') }
        it { is_expected.to contain_class('xdmod::ondemand').that_comes_before('Class[xdmod::apache]') }
      end

      context 'when compute => true only' do
        let(:default_params) do
          {
            web: false,
            database: false,
            compute: true,
            supremm_resources: [{
              'resource' => 'example',
              'resource_id' => 1,
              'enabled' => true,
              'datasetmap' => 'pcp',
              'pcp_log_dir' => '/data/pcp-data/example',
            }],
            pcp_resource: 'example',
          }
        end
        let(:params) { default_params }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to create_class('xdmod::supremm::compute::pcp') }
        it { is_expected.to contain_class('xdmod::params') }

        context 'xdmod::supremm::compute::pcp' do
          it do
            is_expected.to contain_pcp__pmlogger('supremm').with(ensure: 'present',
                                                                 hostname: 'LOCALHOSTNAME',
                                                                 primary: 'true',
                                                                 socks: 'false',
                                                                 log_dir: '/data/pcp-data/example/LOCALHOSTNAME',
                                                                 args: '-r',
                                                                 config_path: '/etc/pcp/pmlogger/pmlogger-supremm.config')
          end

          it do
            is_expected.to contain_pcp__pmda('proc').with(has_package: 'false',
                                                          config_path: '/var/lib/pcp/pmdas/proc/hotproc.conf')
          end

          it do
            config_content = catalogue.resource('pcp::pmda', 'proc').send(:parameters)[:config_content]
            expect(config_content).to match(my_fixture_read('hotproc'))
          end

          context 'pcp_pmlogger_date_path => true' do
            let(:params) { default_params.merge(pcp_pmlogger_path_suffix: '$(date +%Y/%m/%d)') }

            it do
              is_expected.to contain_pcp__pmlogger('supremm').with_log_dir('/data/pcp-data/example/LOCALHOSTNAME/$(date +%Y/%m/%d)')
            end
          end
        end

        context 'when pcp_resource is undefined' do
          let(:params) do
            {
              web: false,
              database: false,
              compute: true,
            }
          end

          it 'raises an error' do
            expect { is_expected.to compile }.to raise_error(%r{pcp_resource must be defined})
          end
        end
      end
    end
  end
end
