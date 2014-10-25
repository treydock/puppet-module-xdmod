require 'puppet'
require 'puppet/type/xdmod_portal_setting'
describe 'Puppet::Type.type(:xdmod_portal_setting)' do
  before :each do
    @xdmod_portal_setting = Puppet::Type.type(:xdmod_portal_setting).new(:name => 'vars/foo', :value => 'bar')
  end
  it 'should require a name' do
    expect {
      Puppet::Type.type(:xdmod_portal_setting).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end
  it 'should not expect a name with whitespace' do
    expect {
      Puppet::Type.type(:xdmod_portal_setting).new(:name => 'f oo')
    }.to raise_error(Puppet::Error, /Invalid xdmod_portal_setting/)
  end
  it 'should fail when there is no section' do
    expect {
      Puppet::Type.type(:xdmod_portal_setting).new(:name => 'foo')
    }.to raise_error(Puppet::Error, /Invalid xdmod_portal_setting/)
  end
  it 'should not require a value when ensure is absent' do
    Puppet::Type.type(:xdmod_portal_setting).new(:name => 'vars/foo', :ensure => :absent)
  end
  it 'should require a value when ensure is present' do
    expect {
      Puppet::Type.type(:xdmod_portal_setting).new(:name => 'vars/foo', :ensure => :present)
    }.to raise_error(Puppet::Error, /Property value must be set/)
  end
  it 'should accept a valid value' do
    @xdmod_portal_setting[:value] = 'bar'
    @xdmod_portal_setting[:value].should == 'bar'
  end
  it 'should not accept a value with whitespace' do
    @xdmod_portal_setting[:value] = 'b ar'
    @xdmod_portal_setting[:value].should == 'b ar'
  end
  it 'should accept valid ensure values' do
    @xdmod_portal_setting[:ensure] = :present
    @xdmod_portal_setting[:ensure].should == :present
    @xdmod_portal_setting[:ensure] = :absent
    @xdmod_portal_setting[:ensure].should == :absent
  end
  it 'should not accept invalid ensure values' do
    expect {
      @xdmod_portal_setting[:ensure] = :latest
    }.to raise_error(Puppet::Error, /Invalid value/)
  end

  describe 'autorequire File resources' do
    it 'should autorequire /etc/nfsmount.conf' do
      conf = Puppet::Type.type(:file).new(:name => '/etc/xdmod/portal_settings.ini')
      catalog = Puppet::Resource::Catalog.new
      catalog.add_resource @xdmod_portal_setting
      catalog.add_resource conf
      rel = @xdmod_portal_setting.autorequire[0]
      rel.source.ref.should == conf.ref
      rel.target.ref.should == @xdmod_portal_setting.ref
    end
  end
end
