require 'network_overview'

class NetworkOverview
  describe NmapXMLParser do
    it 'parses nmap xml output into a list of hosts' do
      xml = File.read('spec/fixtures/nmap_output.xml')
      parser = NetworkOverview::NmapXMLParser.new
      parsed = parser.parse(xml)

      expect(parsed).to eq [
        Host.new('192.168.1.1',
                 '00:14:BF:10:17:A2',
                 'Cisco-Linksys'),
        Host.new('192.168.1.2',
                 '80:1F:02:AA:31:BD',
                 'Edimax Technology Co.'),
      ]
    end
  end
end

