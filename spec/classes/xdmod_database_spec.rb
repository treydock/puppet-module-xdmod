require 'spec_helper'

describe 'xdmod::database' do
  let :facts do
    {
      :osfamily => 'RedHat',
    }
  end

  it { should create_class('xdmod::database') }
  it { should contain_class('xdmod::params') }
  it { should contain_class('mysql::server') }

  [
    'mod_hpcdb',
    'mod_logger',
    'mod_shredder',
    'moddb',
    'modw',
    'modw_aggregates',
  ].each do |db|
    it "should create Mysql::Db[#{db}]" do
      should contain_mysql__db(db).with({
        :ensure       => 'present',
        :user         => 'xdmod',
        :password     => 'changeme',
        :host         => 'localhost',
        :charset      => 'utf8',
        :collate      => 'utf8_bin',
        :grant        => ['ALL'],
      })
    end
  end

end
