# frozen_string_literal: true

collection = ENV['BEAKER_PUPPET_COLLECTION'] || 'puppet5'
RSpec.configure do |c|
  c.before :suite do
    if collection == 'puppet6'
      on hosts, puppet('module', 'install', 'puppetlabs-yumrepo_core', '--version', '">= 1.0.1 < 2.0.0"'), acceptable_exit_codes: [0, 1]
      on hosts, puppet('module', 'install', 'puppetlabs-cron_core', '--version', '">= 1.0.0 < 2.0.0"'), acceptable_exit_codes: [0, 1]
    end
    on hosts, 'puppet module install trepasi-geoip  --ignore-dependencies'
    on hosts, 'puppet config set --section main show_diff true'
    on hosts, 'mkdir -p /etc/puppetlabs/facter/facts.d'
    create_remote_file(hosts, '/etc/puppetlabs/facter/facts.d/domain.txt', "domain=localdomain\n")
  end
end

hiera_yaml = <<-HIERA
---
version: 5
defaults:
  datadir: data
  data_hash: yaml_data
hierarchy:
- name: "Common"
  path: "common.yaml"
HIERA
common_yaml = <<-HIERA
---
mysql::server::override_options:
  mysqld:
    sql-mode: "''"
HIERA
if ENV['GEOIP_USERID'] && ENV['GEOIP_LICENSEKEY']
  common_yaml += <<-HIERA
xdmod::ondemand::geoip_userid: "#{ENV['GEOIP_USERID']}"
xdmod::ondemand::geoip_licensekey: "#{ENV['GEOIP_LICENSEKEY']}"
  HIERA
end
# Hack to work around issues with recent systemd and docker and running services as non-root
if fact('os.family') == 'RedHat' && fact('os.release.major').to_i >= 7
  common_yaml += <<-HIERA
pcp::pcp_conf_configs:
  PCP_USER: root
  PCP_GROUP: root
mongodb::server::user: root
mongodb::server::group: root
  HIERA

  mongod_hack = <<-HIERA
[Service]
User=root
Group=root
ExecStartPre=
ExecStartPre=/usr/bin/mkdir -p /var/run/mongodb
ExecStartPre=/usr/bin/chown root:root /var/run/mongodb
  HIERA

  on hosts, 'mkdir -p /etc/systemd/system/mongod.service.d'
  create_remote_file(hosts, '/etc/systemd/system/mongod.service.d/hack.conf', mongod_hack)
end

# Hack to fix issue with notify services not starting
if fact('os.family') == 'RedHat' && fact('os.release.major').to_i >= 8
  on hosts, 'mkdir -p /etc/systemd/system/{pmcd,pmlogger,pmie}.service.d'
  override = <<-OVERRIDE
[Service]
Type=simple
  OVERRIDE
  create_remote_file(hosts, '/etc/systemd/system/pmcd.service.d/override.conf', override)
  create_remote_file(hosts, '/etc/systemd/system/pmlogger.service.d/override.conf', override)
  create_remote_file(hosts, '/etc/systemd/system/pmie.service.d/override.conf', override)
end

create_remote_file(hosts, '/etc/puppetlabs/puppet/hiera.yaml', hiera_yaml)
on hosts, 'mkdir -p /etc/puppetlabs/puppet/data'
create_remote_file(hosts, '/etc/puppetlabs/puppet/data/common.yaml', common_yaml)
