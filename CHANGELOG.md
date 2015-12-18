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
