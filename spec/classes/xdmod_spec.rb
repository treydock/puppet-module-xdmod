require 'spec_helper'

describe 'xdmod' do
  on_supported_os({
    :supported_os => [
      {
        "operatingsystem" => "CentOS",
        "operatingsystemrelease" => ["6", "7"],
      }
    ]
  }).each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile.with_all_deps }

      it { should create_class('xdmod') }
      it { should contain_class('xdmod::params') }

      it { should contain_anchor('xdmod::start').that_comes_before('Class[xdmod::user]') }
      it { should contain_class('xdmod::user').that_comes_before('Class[xdmod::install]') }
      it { should contain_class('xdmod::install').that_comes_before('Class[xdmod::database]') }
      it { should contain_class('xdmod::database').that_comes_before('Class[xdmod::config]') }
      it { should contain_class('xdmod::config').that_comes_before('Class[xdmod::config::simplesamlphp]') }
      it { should contain_class('xdmod::config::simplesamlphp').that_comes_before('Class[xdmod::apache]') }
      it { should contain_class('xdmod::apache').that_comes_before('Anchor[xdmod::end]') }
      it { should contain_anchor('xdmod::end') }

      it_behaves_like 'xdmod::user', facts
      it_behaves_like 'xdmod::install', facts
      it_behaves_like 'xdmod::database', facts
      it_behaves_like 'xdmod::config', facts
      it_behaves_like 'xdmod::config::simplesamlphp', facts
      it_behaves_like 'xdmod::apache', facts

      context 'when akrr => true' do
        let(:params) {{ :akrr => true }}

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to compile }
      end

      context 'when supremm => true' do
        let(:params) {{ :supremm => true, :web => true }}

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to compile }
      end

      context 'when database => true && supremm_database => true' do
        let(:params) {{ :database => true, :supremm_database => true }}

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to compile }
      end

      context 'when web => false' do
        let(:params) {{ :web => false }}

        it { is_expected.to compile.with_all_deps }

        it { should contain_anchor('xdmod::start').that_comes_before('Class[xdmod::database]') }
        it { should contain_class('xdmod::database').that_comes_before('Anchor[xdmod::end]') }
        it { should contain_anchor('xdmod::end') }

        it { should_not contain_class('xdmod::install') }
        it { should_not contain_class('xdmod::config') }

        it_behaves_like 'xdmod::database', facts
      end

      context 'when database => false' do
        let(:params) {{ :database => false }}

        it { is_expected.to compile.with_all_deps }

        it { should contain_anchor('xdmod::start').that_comes_before('Class[xdmod::user]') }
        it { should contain_class('xdmod::user').that_comes_before('Class[xdmod::install]') }
        it { should contain_class('xdmod::install').that_comes_before('Class[xdmod::config]') }
        it { should contain_class('xdmod::config').that_comes_before('Class[xdmod::config::simplesamlphp]') }
        it { should contain_class('xdmod::config::simplesamlphp').that_comes_before('Class[xdmod::apache]') }
        it { should contain_class('xdmod::apache').that_comes_before('Anchor[xdmod::end]') }
        it { should contain_anchor('xdmod::end') }

        it { should_not contain_class('xdmod::database') }

        it_behaves_like 'xdmod::user', facts
        it_behaves_like 'xdmod::install', facts
        it_behaves_like 'xdmod::config', facts
        it_behaves_like 'xdmod::config::simplesamlphp', facts
        it_behaves_like 'xdmod::apache', facts
      end

      context 'when compute => true only' do
        let(:default_params) {{
          :web              => false,
          :database         => false,
          :compute          => true,
          :supremm_resources => [{
            'resource' => 'example',
            'resource_id' => 1,
            'enabled' => true,
            'datasetmap' => 'pcp',
            'pcp_log_dir' => '/data/pcp-data/example',
          }],
          :pcp_resource     => 'example',
        }}
        let(:params) { default_params }

        it { is_expected.to compile.with_all_deps }

        it { should create_class('xdmod::supremm::compute::pcp') }
        it { should contain_class('xdmod::params') }

        it_behaves_like 'xdmod::supremm::compute::pcp'

        context 'when pcp_resource is undefined' do
          let(:params) {{
            :web          => false,
            :database     => false,
            :compute      => true,
          }}

          it 'should raise an error' do
            expect { is_expected.to compile }.to raise_error(/pcp_resource must be defined/)
          end
        end
      end

      # Test validate_bool parameters
      [
        :database,
        :web,
        :enable_appkernel,
      ].each do |param|
        context "with #{param} => 'foo'" do
          let(:params) {{ param => 'foo' }}
          it { expect { should create_class('xdmod') }.to raise_error(Puppet::Error, /expects a Boolean value/) }
        end
      end
    end
  end
end
