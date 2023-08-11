# frozen_string_literal: true

shared_examples_for 'xdmod::database' do |_facts|
  [
    'mod_hpcdb',
    'mod_logger',
    'mod_shredder',
    'moddb',
    'modw',
    'modw_aggregates'
  ].each do |db|
    it "creates Mysql::Db[#{db}]" do
      is_expected.to contain_mysql__db(db).with(ensure: 'present',
                                                user: 'xdmod',
                                                password: 'changeme',
                                                host: 'localhost',
                                                charset: 'latin1',
                                                collate: 'latin1_swedish_ci',
                                                grant: ['ALL'])
    end
  end

  it { is_expected.not_to contain_mysql__db('modw_cloud') }
  it { is_expected.not_to contain_mysql__db('mod_appkernel') }
  it { is_expected.not_to contain_mysql__db('mod_akrr') }
  it { is_expected.not_to contain_mysql_grant('akrr@localhost/modw.resourcefact') }

  context 'when enable_cloud_realm => true' do
    let(:params) { { enable_cloud_realm: true } }

    it do
      is_expected.to contain_mysql__db('modw_cloud').with(
        ensure: 'present',
        user: 'xdmod',
        password: 'changeme',
        host: 'localhost',
        charset: 'latin1',
        collate: 'latin1_swedish_ci',
        grant: ['ALL'],
      )
    end
  end

  context 'when enable_ondemand => true' do
    let(:params) { { enable_ondemand: true } }

    it do
      is_expected.to contain_mysql__db('modw_ondemand').with(
        ensure: 'present',
        user: 'xdmod',
        password: 'changeme',
        host: 'localhost',
        charset: 'latin1',
        collate: 'latin1_swedish_ci',
        grant: ['ALL'],
      )
    end
  end

  context 'when enable_appkernel => true' do
    let(:params) { { enable_appkernel: true } }

    it do
      is_expected.to contain_mysql__db('mod_appkernel').with(ensure: 'present',
                                                             user: 'akrr',
                                                             password: 'changeme',
                                                             host: 'localhost',
                                                             charset: 'latin1',
                                                             collate: 'latin1_swedish_ci',
                                                             grant: ['ALL'])
    end

    it do
      is_expected.to contain_mysql__db('mod_akrr').with(ensure: 'present',
                                                        user: 'akrr',
                                                        password: 'changeme',
                                                        host: 'localhost',
                                                        charset: 'latin1',
                                                        collate: 'latin1_swedish_ci',
                                                        grant: ['ALL'])
    end

    it do
      is_expected.to contain_mysql__db('modw-akrr').with(ensure: 'present',
                                                         dbname: 'modw',
                                                         user: 'akrr',
                                                         password: 'changeme',
                                                         host: 'localhost',
                                                         charset: 'latin1',
                                                         collate: 'latin1_swedish_ci',
                                                         grant: ['SELECT'])
    end

    context 'when akrr_host != web_host' do
      let(:params) { { enable_appkernel: true, akrr_host: 'foo' } }

      it { is_expected.to contain_mysql__db('mod_appkernel').with_host('foo') }
      it { is_expected.to contain_mysql__db('mod_akrr').with_host('foo') }
    end
  end
end
