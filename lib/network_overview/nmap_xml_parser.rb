require 'nokogiri'

class NetworkOverview
  class NmapXMLParser
    def parse(xml)
      doc = Nokogiri::XML(xml)

      doc.search("host").map do |node|
        next if node.at("status").attr("reason") == "localhost-response"

        ip_node, mac_node = node.search("address")

        Host.new(ip_node.attr('addr'),
                 mac_node.attr('addr'),
                 mac_node.attr('vendor'))
      end.compact
    end
  end
end
