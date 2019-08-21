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
    'lib',
  ),
)
require 'spec_helper'
provider_class = Puppet::Type.type(:xdmod_supremm_setting).provider(:ini_setting)
describe provider_class do
  let(:resource) do
    Puppet::Type::Xdmod_supremm_setting.new(
      name: 'vars/foo', value: 'bar',
    )
  end
  let(:provider) do
    provider_class.new(resource)
  end

  it 'sets section and setting' do
    expect(provider.section).to eq 'vars'
    expect(provider.setting).to eq 'foo'
  end
end
