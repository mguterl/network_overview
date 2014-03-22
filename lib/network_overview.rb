require 'network_overview/version'
require 'network_overview/host_scanner'
require 'network_overview/gmail_notifier'
require 'ostruct'

class NetworkOverview
  Device = Struct.new(:name, :mac_address)
  Host = Struct.new(:ip, :mac_address, :vendor)

  def self.configure
    yield config
  end

  def self.config
    @config ||= OpenStruct.new
  end

  def initialize(known_devices, hosts)
    @known_devices = known_devices
    @hosts = hosts
    @known_mac_addresses = @known_devices.map &:mac_address
    @host_mac_addresses = @hosts.map &:mac_address
  end

  def connected_devices
    @known_devices.select { |device|
      @host_mac_addresses.include? device.mac_address
    }
  end

  def disconnected_devices
    @known_devices.reject { |device|
      @host_mac_addresses.include? device.mac_address
    }
  end

  def unknown_hosts
    @hosts.reject { |host|
      @known_mac_addresses.include? host.mac_address
    }
  end

end
