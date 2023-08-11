# frozen_string_literal: true

Puppet::Type.type(:xdmod_portal_setting).provide(
  :ini_setting,
  parent: Puppet::Type.type(:ini_setting).provider(:ruby),
) do
  def section
    resource[:name].split('/', 2).first
  end

  def setting
    resource[:name].split('/', 2).last
  end

  def separator
    ' = '
  end

  def self.file_path
    '/etc/xdmod/portal_settings.ini'
  end
end
