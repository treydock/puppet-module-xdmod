require 'spec_helper'

describe 'xdmod' do
  on_supported_os({
    :supported_os => [
      {
        'operatingsystem' => 'CentOS',
        'operatingsystemrelease' => ['6', '7'],
      }
    ]
  }).each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/dne',
        })
      end

      it { is_expected.to compile.with_all_deps }

      it { should create_class('xdmod') }
      it { should contain_class('xdmod::params') }

      it { should contain_anchor('xdmod::start').that_comes_before('Class[xdmod::install]') }
      it { should contain_class('xdmod::install').that_comes_before('Class[xdmod::database]') }
      it { should contain_class('xdmod::database').that_comes_before('Class[xdmod::config]') }
      it { should contain_class('xdmod::config').that_comes_before('Class[xdmod::apache]') }
      it { should contain_class('xdmod::apache').that_comes_before('Anchor[xdmod::end]') }
      it { should contain_anchor('xdmod::end') }

      it_behaves_like 'xdmod::install'
      it_behaves_like 'xdmod::database'
      it_behaves_like 'xdmod::config'
      it_behaves_like 'xdmod::apache'

      context 'when web => false' do
        let(:params) {{ :web => false }}

        it { is_expected.to compile.with_all_deps }

        it { should contain_anchor('xdmod::start').that_comes_before('Class[xdmod::database]') }
        it { should contain_class('xdmod::database').that_comes_before('Anchor[xdmod::end]') }
        it { should contain_anchor('xdmod::end') }

        it { should_not contain_class('xdmod::install') }
        it { should_not contain_class('xdmod::config') }

        it_behaves_like 'xdmod::database'
      end

      context 'when database => false' do
        let(:params) {{ :database => false }}

        it { is_expected.to compile.with_all_deps }

        it { should contain_anchor('xdmod::start').that_comes_before('Class[xdmod::install]') }
        it { should contain_class('xdmod::install').that_comes_before('Class[xdmod::config]') }
        it { should contain_class('xdmod::config').that_comes_before('Class[xdmod::apache]') }
        it { should contain_class('xdmod::apache').that_comes_before('Anchor[xdmod::end]') }
        it { should contain_anchor('xdmod::end') }

        it { should_not contain_class('xdmod::database') }

        it_behaves_like 'xdmod::install'
        it_behaves_like 'xdmod::config'
        it_behaves_like 'xdmod::apache'
      end

      # Test validate_bool parameters
      [
        :database,
        :web,
      ].each do |param|
        context "with #{param} => 'foo'" do
          let(:params) {{ param => 'foo' }}
          it { expect { should create_class('xdmod') }.to raise_error(Puppet::Error, /is not a boolean/) }
        end
      end
    end
  end
end
