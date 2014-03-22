require 'optparse'

class NetworkOverview
  class CLI
    def self.run(argv)
      load 'config.rb'
      new.run(argv)
    end

    def self.parse_argv(argv = ARGV)
      options = {
        notifications: false,
        summary: true,
      }

      OptionParser.new do |opts|
        opts.banner = "Usage: network_overview [options]"

        opts.on("-n", "--[no-]notifications", "Send notifications") do |n|
          options[:notifications] = n
        end

        opts.on("-s", "--[no-]summary", "Print summary") do |s|
          options[:summary] = s
        end
      end.parse(argv)

      options
    end

    def initialize(config = NetworkOverview.config)
      @config = config
    end

    def run(argv)
      scanner = HostScanner.new(@config.network)
      overview = NetworkOverview.new(@config.known_devices, scanner.hosts)
      send_notification overview
    end

    def send_notification(network_overview)
      if send_notification?(network_overview)
        @config.notifier.notify(network_overview)
      end
    end

    def send_notification?(network_overview)
      !network_overview.unknown_hosts.empty?
    end
  end
end

