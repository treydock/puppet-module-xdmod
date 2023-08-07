# frozen_string_literal: true

require 'puppet'
require 'puppet/type/xdmod_supremm_setting'
describe 'Puppet::Type.type(:xdmod_supremm_setting)' do
  let(:xdmod_supremm_setting) do
    Puppet::Type.type(:xdmod_supremm_setting).new(name: 'vars/foo', value: 'bar')
  end

  it 'requires a name' do
    expect {
      Puppet::Type.type(:xdmod_supremm_setting).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'does not expect a name with whitespace' do
    expect {
      Puppet::Type.type(:xdmod_supremm_setting).new(name: 'f oo')
    }.to raise_error(Puppet::Error, %r{Invalid xdmod_supremm_setting})
  end

  it 'fails when there is no section' do
    expect {
      Puppet::Type.type(:xdmod_supremm_setting).new(name: 'foo')
    }.to raise_error(Puppet::Error, %r{Invalid xdmod_supremm_setting})
  end

  it 'does not require a value when ensure is absent' do
    Puppet::Type.type(:xdmod_supremm_setting).new(name: 'vars/foo', ensure: :absent)
  end

  it 'requires a value when ensure is present' do
    expect {
      Puppet::Type.type(:xdmod_supremm_setting).new(name: 'vars/foo', ensure: :present)
    }.to raise_error(Puppet::Error, %r{Property value must be set})
  end

  it 'accepts a valid value' do
    xdmod_supremm_setting[:value] = 'bar'
    expect(xdmod_supremm_setting[:value]).to eq '"bar"'
  end

  it 'does not accept a value with whitespace' do
    xdmod_supremm_setting[:value] = 'b ar'
    expect(xdmod_supremm_setting[:value]).to eq '"b ar"'
  end

  it 'accepts valid ensure values' do
    xdmod_supremm_setting[:ensure] = :present
    expect(xdmod_supremm_setting[:ensure]).to eq :present
    xdmod_supremm_setting[:ensure] = :absent
    expect(xdmod_supremm_setting[:ensure]).to eq :absent
  end

  it 'does not accept invalid ensure values' do
    expect {
      xdmod_supremm_setting[:ensure] = :latest
    }.to raise_error(Puppet::Error, %r{Invalid value})
  end

  describe 'autorequire File resources' do
    it 'autorequires /etc/xdmod/portal_settings.d/supremm.ini' do
      conf = Puppet::Type.type(:file).new(name: '/etc/xdmod/portal_settings.d/supremm.ini')
      catalog = Puppet::Resource::Catalog.new
      catalog.add_resource xdmod_supremm_setting
      catalog.add_resource conf
      rel = xdmod_supremm_setting.autorequire[0]
      expect(rel.source.ref).to eq conf.ref
      expect(rel.target.ref).to eq xdmod_supremm_setting.ref
    end
  end
end
