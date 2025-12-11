# puppet-module-xdmod

[![Puppet Forge](http://img.shields.io/puppetforge/v/treydock/xdmod.svg)](https://forge.puppetlabs.com/treydock/xdmod)
[![CI Status](https://github.com/treydock/puppet-module-xdmod/workflows/CI/badge.svg?branch=master)](https://github.com/treydock/puppet-module-xdmod/actions?query=workflow%3ACI)


#### Table of Contents

1. [Overview](#overview)
    * [Open XDMoD Compatibility](#open-xdmod-compatibility)
    * [Optional Dependencies](#optional-dependencies)
    * [Handling upgrades](#handling-upgrades)
    * [Version 10.x upgrade notes](#version-10x-upgrade-notes)
2. [Usage - Configuration options](#usage)
3. [Reference - Parameter and detailed reference to all options](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Overview

This module will manage [Open XDMoD](https://open.xdmod.org/).  This module works best when paired with Hiera for defining parameter values.

This module is designed so that different hosts can run the various components of Open XDMoD.

### Open XDMoD Compatibility

* puppet-module-xdmod **2.x** supports Open XDMoD **7.5.x**
* puppet-module-xdmod **3.x** supports Open XDMoD **8.0.x**
* puppet-module-xdmod **4.x** supports Open XDMoD **8.1.x**
* puppet-module-xdmod **5.x** supports Open XDMoD **8.5.x**
* puppet-module-xdmod **6.x** supports Open XDMoD **9.0.x**
* puppet-module-xdmod **7.x** supports Open XDMoD **9.5.x**
* puppet-module-xdmod **8.x** and **9.x** supports Open XDMoD **10.0.x**
* puppet-module-xdmod **10.x** supports Open XDMoD **10.5.x**

### Optional Dependencies

When defining `xdmod::ondemand::geoip_userid` and `xdmod::ondemand::geoip_licensekey` the module [trepasi/geoip](https://forge.puppet.com/modules/trepasi/geoip) is required.

### Handling upgrades

This module does not support XDMOD upgrades. It's recommended to perform upgrades manually at this time. 

XDMOD upgrades involve running the `xdmod-upgrade` command which does not lend itself to being handled by automation.

The general process with this module for upgrades is the following:

1. Upgrade all XDMOD packages
1. Run `xdmod-upgrade`
1. Run Puppet with a version and changes specific to new XDMOD version

### Version 10.x upgrade notes

The mechanism to handle cron jobs was changed with 10.x of this module so that there is a single cron script that handles all the shreds and ingests.  This change to cron jobs does not apply to appkernel/AKRR.

The single cron job is set using the `xdmod::cron_times` parameter.  The following parameters are removed as related to cron jobs:

* xdmod::batch_export_cron_times
* xdmod::supremm_update_cron_times
* xdmod::ingest_jobscripts_cron_times
* xdmod::aggregate_supremm_cron_times
* xdmod::storage_cron_times

## Usage

The XDMOD host needs to include the `xdmod` class:

```puppet
include xdmod
```

Examples of some hiera values that may be useful to set globally

```yaml
xdmod::version: '10.5.0'
# Disable roles that are enabled by default
xdmod::web: false
xdmod::database: false
# Define which features of XDMoD are enabled
xdmod::enable_appkernel: true
xdmod::enable_supremm: true
# Define site information
xdmod::organization_name: My Org
xdmod::organization_abbrev: MO
# Define resources
xdmod::resources:
  - resource: example
    name: Example
    resource_type_id: 1
    pi_column: account
    shared_jobs: true
xdmod::resource_specs:
  - resource: example
    processors: 12000
    nodes: 500
    ppn: 24
xdmod::supremm_resources:
  - resource: example
    resource_id: 1
    enabled: true
    datasource: pcp
    hardware:
      gpfs: /gpfs
    pcp_log_dir: /data/pcp-data/example
    batchscript:
      path: /data/job-scripts/example
# Set parameters used by multiple roles
xdmod::web_host: 'xdmod.domain'
xdmod::akrr_host: 'akrr.domain'
xdmod::database_password: 'xdmod-db-password-here'
xdmod::database_host: 'dbhost.domain'
xdmod::akrr_restapi_rw_password: 'some-password'
xdmod::akrr_restapi_ro_password: 'some-password'
xdmod::akrr_database_password: 'some-password'
xdmod::supremm_mongodb_password: 'some-password'
xdmod::supremm_mongodb_host: 'mongodb.domain'
xdmod::pcp_resource:
  - example
xdmod::cron_times:
  - 1
  - 0
# Ensure cron times are after the times scheduled to run app kernels
xdmod::akrr_ingestor_cron_times:
  - 0
  - 7
xdmod::appkernel_reports_manager_cron_times:
  - 0
  - 8
```

Example of how to enable OnDemand module:

```yaml
xdmod::enable_ondemand: true
xdmod::resources:
  - resource: ondemand
    name: OnDemand
    resource_type: Gateway
    shred_directory: /path/to/ondemand/logs/directory
    hostname: https://ondemand.example.com
xdmod::ondemand::geoip_userid: 00001
xdmod::ondemand::geoip_licensekey: secret-key
```

Using Prometheus for SUPREMM job metric collection:

```yaml
xdmod::supremm_cron_index_archives: false
xdmod::supremm_resources:
  - resource: example
    resource_id: 1
    enabled: true
    datasource: prometheus
    hardware:
      gpfs: /gpfs
    prom_host: prometheus.example.com:9090
    batchscript:
      path: /data/job-scripts/example
```

If you run a local yum repo for XDMoD packages

```yaml
xdmod::local_repo_name: 'local-repo-name-here'
```

Enable Federated logins for XDMoD web host

```yaml
xdmod::web: true
xdmod::manage_simplesamlphp: true
xdmod::simplesamlphp_config_source: 'puppet:///modules/site_xdmod/simplesamlphp/config.php'
xdmod::simplesamlphp_authsources_source: 'puppet:///modules/site_xdmod/simplesamlphp/authsources.php'
```

Run the XDMoD web interface and AKRR web service with SUPReMM support

```yaml
xdmod::web: true
xdmod::akrr: true
xdmod::database: false
xdmod::enable_appkernel: true
xdmod::enable_supremm: true
xdmod::enable_update_check: false
```

Host the MySQL databases for XDMoD, AKRR and SUPReMM

```yaml
xdmod::web: false
xdmod::database: true
xdmod::enable_appkernel: true
xdmod::enable_supremm: true
```

A compute node that will collect PCP data for SUPReMM.  The `xdmod::supremm::compute::pcp` class will declare the pcp class by default.  The metrics defined in `pcp_static_metrics` and `pcp_standard_metrics` will also define `pcp::pmda` resources based on which metrics are enabled.  See `xdmod::params` for some defaults.  The infiniband, perfevent, nvidia, gpfs, slurm, and mic metrics are commented out.

```yaml
xdmod::web: false
xdmod::database: false
xdmod::compute: true
xdmod::pcp_static_metrics:
  - 'metrics that don't change often go here'
  - '#comments can be defined too and will be present in config file as comments'
  - 'more static metrics'
xdmod::pcp_standard_metrics:
  - 'metrics that change often like during a job'
  - '#comments can be defined too and will be present in config file as comments'
  - 'more standard metrics'
```

If you wish to use `include` style class declaration for the pcp class then the default pmlogger and pmie need to be removed and pmlogger_daily in cron needs to have modified arguments.

```yaml
pcp::include_default_pmlogger: false
pcp::include_default_pmie: false
pcp::pmlogger_daily_args: '-M -k forever'
xdmod::web: false
xdmod::database: false
xdmod::compute: true
xdmod::pcp_declare_method: 'include'
xdmod::pcp_static_metrics:
  - 'metrics that don't change often go here'
  - '#comments can be defined too and will be present in config file as comments'
  - 'more static metrics'
xdmod::pcp_standard_metrics:
  - 'metrics that change often like during a job'
  - '#comments can be defined too and will be present in config file as comments'
  - 'more standard metrics'
```

A host that needs to run the SUPReMM job summarization.

```yaml
xdmod::supremm: true
```

A MongoDB host needs to be setup for SUPReMM

```yaml
xdmod::web: false
xdmod::database: false
xdmod::supremm_database: true
```

## Reference

[http://treydock.github.io/puppet-module-xdmod/](http://treydock.github.io/puppet-module-xdmod/)

## Limitations

This module has been tested on:

* RedHat/CentOS 7
* RedHat/Rocky/AlmaLinux 8
