require 'network_overview/nmap_xml_parser'

class NetworkOverview
  class HostScanner
    def initialize(network = '192.168.1.0/24')
      @network = network
      @parser = NmapXMLParser.new
    end

    def hosts
      @parser.parse command_output
    end

    private

    def command_output
      `sudo -S nmap -oX - -sP #{@network}`
    end
  end
end
