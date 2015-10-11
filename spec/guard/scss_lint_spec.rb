require 'spec_helper'
require 'guard/scss_lint'
require 'scss_lint'

describe Guard::ScssLint, exclude_stubs: [Guard::Plugin] do
  let(:options) { {} }
  subject(:guard) { Guard::ScssLint.new(options) }

  before do
    meths = %w(info warning error deprecation debug notify color color_enabled?)
    meths.each do |type|
      allow(Guard::Compat::UI).to receive(type.to_sym)
    end
  end

  describe '#options' do
    subject { super().options }

    context 'by default' do
      let(:options) { {} }

      describe '[:all_on_start]' do
        subject { super()[:all_on_start] }
        it { should be_truthy }
      end

      describe '[:keep_failed]' do
        subject { super()[:keep_failed] }
        it { should be_falsy }
      end

      describe '[:config]' do
        subject { super()[:config] }
        it 'uses default config from SCSS Lint' do
          expect(guard.config).to eq(SCSSLint::Config.default)
        end
      end
    end

    context 'passed in config file' do
      let(:options) { { config: File.join(Dir.pwd, 'spec', 'configs', 'test-config-2.yml') } }

      describe '[:config]' do
        subject { super()[:config] }
        it 'uses customized config' do
          expect(guard.config).not_to eq(SCSSLint::Config.default)
        end
      end
    end
  end

  describe '#start' do
    context 'when :all_on_start option is enabled' do
      let(:options) { { all_on_start: true } }

      it 'runs all' do
        expect(guard).to receive(:run_all)
        guard.start
        expect(Guard::Compat::UI).to have_received(:info).with("Guard::ScssLint (SCSSLint version #{SCSSLint::VERSION}) is running")
      end
    end

    context 'when :all_on_start option is disabled' do
      let(:options) { { all_on_start: false } }

      it 'does nothing' do
        expect(guard).not_to receive(:run_all)
        guard.start
        expect(Guard::Compat::UI).to have_received(:info).with("Guard::ScssLint (SCSSLint version #{SCSSLint::VERSION}) is running")
      end
    end
  end

  shared_examples 'processes after running', :processes_after_running do
    context 'when passes' do
      it 'prints status message with zero errors' do
        allow_any_instance_of(SCSSLint::Runner).to receive(:run).and_return(true)
        subject
        expect(Guard::Compat::UI).to have_received(:info).with("Guard::ScssLint inspected 1 files, found 0 errors.")
      end

      it 'does not notify of errors' do
        allow_any_instance_of(SCSSLint::Runner).to receive(:run).and_return(true)
        allow_any_instance_of(SCSSLint::Runner).to receive(:failed_paths).and_return([])
        subject
        expect(Guard::Compat::UI).not_to have_received(:notify)
      end
    end

    context 'when failed' do
      it 'prints and notifies status message with non-zero errors' do
        allow_any_instance_of(SCSSLint::Runner).to receive(:run).and_return(false)
        allow_any_instance_of(SCSSLint::Runner).to receive(:lints).and_return([
          SCSSLint::Lint.new(SCSSLint::Linter::PropertySortOrder.new, 'a.scss', SCSSLint::Location.new, 'wrong order')
        ])
        subject
        expect(Guard::Compat::UI).to have_received(:info).with("Guard::ScssLint inspected 1 files, found 1 errors.")
        expect(Guard::Compat::UI).to have_received(:notify).with("1 errors found", title: "Guard ScssLint issues found")
      end
    end
  end

  describe '#run_all', :processes_after_running do
    subject { super().run_all }

    before do
      allow(Guard::Compat).to receive(:matching_files).and_return(['a.scss'])
      allow_any_instance_of(SCSSLint::Runner).to receive(:run).and_return(true)
      allow_any_instance_of(SCSSLint::Runner).to receive(:failed_paths).and_return([])
    end

    it 'inspects all scss files with scss lint' do
      expect_any_instance_of(SCSSLint::Runner).to receive(:run).with(['a.scss'])
      guard.run_all
    end
  end
end
