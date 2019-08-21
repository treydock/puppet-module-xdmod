# puppet-module-xdmod

[![Puppet Forge](http://img.shields.io/puppetforge/v/treydock/xdmod.svg)](https://forge.puppetlabs.com/treydock/xdmod)
[![Build Status](https://travis-ci.org/treydock/puppet-module-xdmod.svg?branch=master)](https://travis-ci.org/treydock/puppet-module-xdmod)

#### Table of Contents

1. [Overview](#overview)
    * [Open XDMoD Compatibility](#open-xdmod-compatibility)
2. [Usage - Configuration options](#usage)
3. [Reference - Parameter and detailed reference to all options](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Overview

This module will manage [Open XDMoD](http://xdmod.sourceforge.net/).  This module works best when paired with Hiera for defining parameter values.

This module is designed so that different hosts can run the various components of Open XDMoD.

### Open XDMoD Compatibility

Open XDMoD Versions         | 7.5.x   | 8.0.x   | 8.5.x  |
:---------------------------|:-------:|:-------:|:------:|
**puppet-module-xdmod 2.x** | **yes** | no      | no     |
**puppet-module-xdmod 3.x** | no      | **yes** | no     |
**puppet-module-xdmod 3.x** | no      | no      | **yes**|

* puppet-module-xdmod **2.x** supports Open XDMoD **7.5.x**
* puppet-module-xdmod **3.x** supports Open XDMoD **8.0.x**
* puppet-module-xdmod **4.x** supports Open XDMoD **8.5.x**

## Usage

Examples of some hiera values that may be useful to set globally

    xdmod::version: '8.0.0'
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
        datasetmap: pcp
        hardware:
          gpfs: /gpfs
        pcp_log_dir: /data/pcp-data/example
        script_dir: /data/job-scripts/example
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
    xdmod::supremm_update_cron_times:
      - 0
      - 4
    xdmod::ingest_jobscripts_cron_times:
      - 0
      - 5
    xdmod::aggregate_supremm_cron_times:
      - 0
      - 7
    # Ensure cron times are after the times scheduled to run app kernels
    xdmod::akrr_ingestor_cron_times:
      - 0
      - 7
    xdmod::appkernel_reports_manager_cron_times:
      - 0
      - 8

If you run a local yum repo for XDMoD packages

    xdmod::local_repo_name: 'local-repo-name-here'

Enable Federated logins for XDMoD web host

    xdmod::web: true
    xdmod::manage_simplesamlphp: true
    xdmod::simplesamlphp_config_source: 'puppet:///modules/site_xdmod/simplesamlphp/config.php'
    xdmod::simplesamlphp_authsources_source: 'puppet:///modules/site_xdmod/simplesamlphp/authsources.php'

Run the XDMoD web interface and AKRR web service with SUPReMM support

    classes:
      - 'xdmod'
    xdmod::web: true
    xdmod::akrr: true
    xdmod::database: false
    xdmod::enable_appkernel: true
    xdmod::enable_supremm: true
    xdmod::enable_update_check: false

Host the MySQL databases for XDMoD, AKRR and SUPReMM

    classes:
      - 'xdmod'
    xdmod::web: false
    xdmod::database: true
    xdmod::enable_appkernel: true
    xdmod::enable_supremm: true

A compute node that will collect PCP data for SUPReMM.  The xdmod::supremm::compute::pcp class will declare the pcp class by default.  The metrics defined in `pcp_static_metrics` and `pcp_standard_metrics` will also define `pcp::pmda` resources based on which metrics are enabled.  See `xdmod::params` for some defaults.  The infiniband, perfevent, nvidia, gpfs, slurm, and mic metrics are commented out.

    classes:
      - 'xdmod'
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

If you wish to use `include` style class declaration for the pcp class then the default pmlogger and pmie need to be removed and pmlogger_daily in cron needs to have modified arguments.

    classes:
      - 'xdmod'
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

A host that needs to run the SUPReMM job summarization.

    classes:
      - 'xdmod'
    xdmod::supremm:: true

A MongoDB host needs to be setup for SUPReMM

    classes:
      - 'xdmod'
    xdmod::web: false
    xdmod::database: false
    xdmod::supremm_database: true

## Reference

[http://treydock.github.io/puppet-module-xdmod/](http://treydock.github.io/puppet-module-xdmod/)

## Limitations

This module has been tested on:

* CentOS 7
* RedHat 7

## Development

### Testing

Testing requires the following dependencies:

* rake
* bundler

Install gem dependencies

    bundle install

Run unit tests

    bundle exec rake spec

Docker based acceptance tests can also be run to test default behavior

    BEAKER_set=centos-7 BEAKER_destroy=no bundle exec rake beaker

Docker acceptance tests can also be run to test full funtionality of multiple systems hosting various XDMoD components

    BEAKER_set=centos-7-multinode BEAKER_destroy=no bundle exec rake beaker_full
