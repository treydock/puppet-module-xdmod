collection = ENV['BEAKER_PUPPET_COLLECTION'] || 'puppet5'
RSpec.configure do |c|
  c.before :suite do
    if collection == 'puppet6'
      on hosts, puppet('module', 'install', 'puppetlabs-yumrepo_core', '--version', '">= 1.0.1 < 2.0.0"'), acceptable_exit_codes: [0, 1]
      on hosts, puppet('module', 'install', 'puppetlabs-cron_core', '--version', '">= 1.0.0 < 2.0.0"'), acceptable_exit_codes: [0, 1]
    end
    on hosts, 'puppet config set --section main show_diff true'
    on hosts, 'mkdir -p /etc/puppetlabs/facter/facts.d'
    create_remote_file(hosts, '/etc/puppetlabs/facter/facts.d/domain.txt', "domain=localdomain\n")
    # Hack to fix startup of mongod in docker
    create_remote_file(hosts, '/etc/sysconfig/mongod', "OPTIONS=\"--smallfiles --quiet -f /etc/mongod.conf\"\n")
  end
end

# Hack to work around issues with recent systemd and docker and running services as non-root
if fact('os.family') == 'RedHat' && fact('os.release.major').to_i >= 7
  hiera_yaml = <<-EOS
---
version: 5
defaults:
  datadir: data
  data_hash: yaml_data
hierarchy:
  - name: "Common"
    path: "common.yaml"
EOS
  common_yaml = <<-EOS
---
pcp::pcp_conf_configs:
  PCP_USER: root
  PCP_GROUP: root
EOS

  create_remote_file(hosts, '/etc/puppetlabs/puppet/hiera.yaml', hiera_yaml)
  on hosts, 'mkdir -p /etc/puppetlabs/puppet/data'
  create_remote_file(hosts, '/etc/puppetlabs/puppet/data/common.yaml', common_yaml)
end
