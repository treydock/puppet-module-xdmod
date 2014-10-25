#
# these tests are a little concerning b/c they are hacking around the
# modulepath, so these tests will not catch issues that may eventually arise
# related to loading these plugins.
# I could not, for the life of me, figure out how to programatcally set the modulepath
$LOAD_PATH.push(
  File.join(
    File.dirname(__FILE__),
    '..',
    '..',
    '..',
    '..',
    'fixtures',
    'modules',
    'inifile',
    'lib')
)
require 'spec_helper'
provider_class = Puppet::Type.type(:xdmod_portal_setting).provider(:ini_setting)
describe provider_class do
  before :each do
    resource = Puppet::Type::Xdmod_portal_setting.new(
      {:name => 'vars/foo', :value => 'bar'}
    )
    @provider = provider_class.new(resource)
  end

  it 'should set section and setting' do
    @provider.section.should == 'vars'
    @provider.setting.should == 'foo'
  end
end
