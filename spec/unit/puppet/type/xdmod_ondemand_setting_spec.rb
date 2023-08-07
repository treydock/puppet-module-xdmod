# frozen_string_literal: true

require 'puppet'
require 'puppet/type/xdmod_ondemand_setting'
describe 'Puppet::Type.type(:xdmod_ondemand_setting)' do
  let(:xdmod_ondemand_setting) do
    Puppet::Type.type(:xdmod_ondemand_setting).new(name: 'vars/foo', value: 'bar')
  end

  it 'requires a name' do
    expect {
      Puppet::Type.type(:xdmod_ondemand_setting).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'does not expect a name with whitespace' do
    expect {
      Puppet::Type.type(:xdmod_ondemand_setting).new(name: 'f oo')
    }.to raise_error(Puppet::Error, %r{Invalid xdmod_ondemand_setting})
  end

  it 'fails when there is no section' do
    expect {
      Puppet::Type.type(:xdmod_ondemand_setting).new(name: 'foo')
    }.to raise_error(Puppet::Error, %r{Invalid xdmod_ondemand_setting})
  end

  it 'does not require a value when ensure is absent' do
    Puppet::Type.type(:xdmod_ondemand_setting).new(name: 'vars/foo', ensure: :absent)
  end

  it 'requires a value when ensure is present' do
    expect {
      Puppet::Type.type(:xdmod_ondemand_setting).new(name: 'vars/foo', ensure: :present)
    }.to raise_error(Puppet::Error, %r{Property value must be set})
  end

  it 'accepts a valid value' do
    xdmod_ondemand_setting[:value] = 'bar'
    expect(xdmod_ondemand_setting[:value]).to eq '"bar"'
  end

  it 'does not accept a value with whitespace' do
    xdmod_ondemand_setting[:value] = 'b ar'
    expect(xdmod_ondemand_setting[:value]).to eq '"b ar"'
  end

  it 'accepts valid ensure values' do
    xdmod_ondemand_setting[:ensure] = :present
    expect(xdmod_ondemand_setting[:ensure]).to eq :present
    xdmod_ondemand_setting[:ensure] = :absent
    expect(xdmod_ondemand_setting[:ensure]).to eq :absent
  end

  it 'does not accept invalid ensure values' do
    expect {
      xdmod_ondemand_setting[:ensure] = :latest
    }.to raise_error(Puppet::Error, %r{Invalid value})
  end

  describe 'autorequire File resources' do
    it 'autorequires /etc/xdmod/portal_settings.d/ondemand.ini' do
      conf = Puppet::Type.type(:file).new(name: '/etc/xdmod/portal_settings.d/ondemand.ini')
      catalog = Puppet::Resource::Catalog.new
      catalog.add_resource xdmod_ondemand_setting
      catalog.add_resource conf
      rel = xdmod_ondemand_setting.autorequire[0]
      expect(rel.source.ref).to eq conf.ref
      expect(rel.target.ref).to eq xdmod_ondemand_setting.ref
    end
  end
end
