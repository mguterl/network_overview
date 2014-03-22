require 'yaml'
require 'gmail'
require 'erb'

class NetworkOverview
  class GmailNotifier

    def initialize(options)
      @username = options.fetch(:username)
      @password = options.fetch(:password)
      @recipients = options.fetch(:recipients)
      @gmail = Gmail.connect!(@username, @password)
    end

    def notify(network_overview)
      # Block syntax on deliver! is biting me in the ass.
      message_body = body_for(network_overview)
      recipients = @recipients

      @gmail.deliver! do
        to recipients
        subject "Network Overview"
        body message_body
      end
    end

    private

    def body_for(network_overview)
      ERB.new(<<-'END_BODY'.gsub(/^\s+/, ""), 0, '-').result binding
        Connected devices: <%= network_overview.connected_devices.size %>
        Unknown hosts: <%= network_overview.unknown_hosts.size %>
        <% network_overview.unknown_hosts.each do |host| -%>
          <%= host.ip %> :: <%= host.mac_address %> :: <%= host.vendor %>
        <% end -%>
      END_BODY
    end

  end
end
