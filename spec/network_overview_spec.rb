require 'network_overview'

describe NetworkOverview do
  let(:overview) { NetworkOverview.new(known_devices, hosts) }
  let(:known_devices) { [NetworkOverview::Device.new('Known', '11:22:33:44:55:66'),
      NetworkOverview::Device.new('Known 2', '22:33:44:55:66:77')] }
  let(:hosts) { [NetworkOverview::Host.new('192.168.1.1', '11:22:33:44:55:66', 'Known'),
                 NetworkOverview::Host.new('192.168.1.25', '00:11:22:33:44:55', 'Unknown')] }

  it "returns hosts that don't match known devices" do
    expect(overview.unknown_hosts).to eq [
      NetworkOverview::Host.new('192.168.1.25', '00:11:22:33:44:55', 'Unknown')
    ]
  end

  it "returns devices that are known and connected" do
    expect(overview.connected_devices).to eq [
      NetworkOverview::Device.new('Known', '11:22:33:44:55:66')
    ]
  end

  it 'returns devices that are known and disconnected' do
    expect(overview.disconnected_devices).to eq [
      NetworkOverview::Device.new('Known 2', '22:33:44:55:66:77')
    ]
  end
end

