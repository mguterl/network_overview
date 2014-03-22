require 'spec_helper'
require 'network_overview/cli'

describe 'Notifications' do
  # We can run all code paths with the exception of nmap and configuration
  # loading.
  # Treat the spec context as a notifier for easy inspection.

  def notify(network_overview)
    @last_notification = network_overview.unknown_hosts.map &:ip
  end

  def known_device(mac)
    NetworkOverview::Device.new('Device Name', mac)
  end

  def check_for_unknown_hosts
    NetworkOverview::CLI.new(config).run([])
  end

  attr_reader :last_notification

  let(:nmap_xml_output) { File.read('spec/fixtures/nmap_output.xml') }
  let(:config) { OpenStruct.new(notifier: self,
                                known_devices: known_devices)
  }

  # This stubbing is unfortunate because if we changed from backticks (`) to
  # some other system call it would stop working.
  before do
    allow(NetworkOverview::HostScanner).to receive(:`).and_return(nmap_xml_output)
  end

  context 'when there are unknown hosts on the network' do
    let(:known_devices) { [known_device('00:14:BF:10:17:A2')] }

    it 'delivers a notification when unknown hosts are detected on network' do
      check_for_unknown_hosts
      expect(last_notification).to eq ['192.168.1.2']
    end
  end

  context 'when there are no unknown hosts on the network' do
    let(:known_devices) {
      [
        known_device('00:14:BF:10:17:A2'),
        known_device('80:1F:02:AA:31:BD'),
      ]
    }

    it 'does not deliver a notification when no unknown hosts are detected on network' do
      check_for_unknown_hosts
      expect(last_notification).to be_nil
    end
  end
end
