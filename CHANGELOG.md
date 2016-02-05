## 2.0.0 - TBD

### Summary

XDMoD 5.5.0 and SUPReMM support

### Changes

* Modified parameters
  * version default is now 5.5.0
  * akrr_source_url updated
  * The use of web_host is split into web_host and akrr_host - previous module behavvior prevented running AKRR on a different host than XDMoD
* Added parameters
  * supremm - Enable SUPReMM job summarization
  * supremm_database - Manage SUPReMM MongoDB database
  * compute - Enable SUPReMM compute compontents (currently PCP)
  * enable_supremm - Enable XDMoD SUPReMM component
  * akrr_host - Hostname of IP of AKRR host
  * xdmod_supremm_package_name - name of the xdmod-supremm package
  * xdmod_supremm_package_url - URL to xdmod-supremm package
  * hierarchy_levels - Defines hierarchy.json contents
  * supremm_version - Version of supremm package (supremm=true)
  * supremm_package_url - URL to supremm package
  * supremm_mongodb_password - Currently does not get used in SUPReMM
  * supremm_mongodb_host - Hostname of MongoDB server used by SUPReMM
  * resource_short_name - Defaults to resource_name
  * resource_long_name - Defaults to resource_name with first letter capitalized
  * resource_id - ID in database for XDMoD resource - defaults to 1
  * job_scripts_dir - Directory holding job script files for SUPReMM
  * use_pcp - Enable PCP when compute=true
  * pcp_declare_method - Use 'include' or 'class' style declaration for PCP class
  * pcp_log_base_dir - Base directory of PCP logs, this must be set for compute=true or supremm=true
  * pcp_log_dir - Defaults to $pcp_log_base_dir/$::hostname
  * pcp_pmlogger_config_template - Template used for pmlogger configuration
  * pcp_pmlogger_config_source - Source of pmlogger configuration
  * pcp_logging_static_freq - static metric frequency
  * pcp_logging_standard_freq - standard metric frequency
  * pcp_static_metrics - static metrics for PCP
  * pcp_standard_metrics - standard metrics for PCP
  * pcp_environ_metrics - environment metrics for PCP
  * pcp_install_pmie_config - Determines if SUPReMM pmie configuration for PCP is managed
  * pcp_pmie_config_template - Config template used for pmie
  * pcp_pmie_config_source - Config source used for pmie
* Manage /etc/xdmod/hierarchy.json
* Add classes to support SUPReMM - all are private classes
* Move local repo resources to xdmod::repo - not used if create_local_repo=false
* Add support for EL7
* Added dependencies
  * puppetlabs/mongodb
  * saz/sudo
  * treydock/pcp
* Expanded acceptance tests to include tests for distributed setup

## 1.0.0 - 2015-12-18

### Summary

Support for XDMoD 5.0.0

### Changes

* Add support for Application Kernels
* Add support for Application Kernels Remote Runner (AKRR)

### Detailed Changes

* Parameters added:
  * `version` - Defines XDMoD version which is used to construct URL for downloading RPMs
  * `create_local_repo` - Sets if a local yum repo should be created for XDMoD
  * `local_repo_name` - Name of local or remote repo containing XDMoD
  * `package_url` - URL used to download XDMoD RPM
  * `apkernels_package_url` - URL used to download XDMoD appkernels RPM
  * `akrr` - Manage AKRR
  * `enable_appkernel`
  * `appkernels_package_name`
  * `akrr_database_user`
  * `akrr_database_password`
  * `akrr_restapi_port`
  * `akrr_restapi_rw_password`
  * `akrr_restapi_ro_password`
  * `akrr_source_url`
  * `akrr_version`
  * `akrr_home`
  * `manage_akrr_user`
  * `akrr_user`
  * `akrr_user_uid`
  * `akrr_user_group`
  * `akrr_user_group_gid`
  * `akrr_user_shell`
  * `akrr_user_home`
  * `akrr_user_managehome`
  * `akrr_user_comment`
  * `akrr_user_system`
  * `akrr_cron_mailto`
* Update XDMoD Apache::Vhost
* Include apache::mod::php class when installing XDMoD web interface
* Set XDMoD portal\_settings.ini value for java_path
* Change default value for `web_host` to be `localhost`
* When database_host is localhost import XDMoD database schema and data upon database creation
* When database_host is not localhost manage xdmod-database-setup.sh and run the script to import schema and data to remote database host
* Added dependencies
  * nanliu/staging
  * hercules-team/augeasproviders_shellvar
* Fix ordering of resources to ensure a fresh install is functional
* Remove support for EL7 - XDMoD only builds RPMs for EL6

## 0.0.1 - 2015-08-19

### Summary

This initial release supports XDMoD 4.5.x
