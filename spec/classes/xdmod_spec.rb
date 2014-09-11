require 'spec_helper'

describe 'xdmod' do
  let :facts do
    {
      :osfamily => 'RedHat',
    }
  end

  it { should create_class('xdmod') }
  it { should contain_class('xdmod::params') }

  it { should contain_anchor('xdmod::start').that_comes_before('Class[xdmod::install]') }
  it { should contain_class('xdmod::install').that_comes_before('Class[xdmod::config]') }
  it { should contain_class('xdmod::config').that_comes_before('Anchor[xdmod::end]') }
  it { should contain_anchor('xdmod::end') }

  include_context 'xdmod::install'
  include_context 'xdmod::config'

  # Test validate_bool parameters
  [

  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param.to_sym => 'foo' }}
      it { expect { should create_class('xdmod') }.to raise_error(Puppet::Error, /is not a boolean/) }
    end
  end
end
