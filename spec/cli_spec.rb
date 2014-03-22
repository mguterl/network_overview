require 'network_overview'

describe NetworkOverview::CLI do
  describe '.parse_argv' do
    let(:options) { NetworkOverview::CLI.parse_argv(argv) }
    let(:argv) { [] }

    it 'defaults to not sending notifications' do
      expect(options[:notifications]).to be_false
    end

    it 'defaults to printing the summary' do
      expect(options[:summary]).to be_true
    end

    context 'with --notifications' do
      let(:argv) { ['--notifications'] }

      it 'enables notifications' do
        expect(options[:notifications]).to be_true
      end
    end

    context 'with --no-summary' do
      let(:argv) { ['--no-summary'] }

      it 'disables printing the summary' do
        expect(options[:summary]).to be_false
      end
    end
  end
end
