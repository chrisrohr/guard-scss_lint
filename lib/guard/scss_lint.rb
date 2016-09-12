require 'guard/compat/plugin'
require 'scss_lint'

require 'rainbow'

module Guard
  class ScssLint < Plugin
    attr_reader :options, :config

    def self.non_namespaced_name
      'scss_lint'
    end

    def initialize(options = {})
      super

      @options = { all_on_start: true }.merge(options)

      config_file = @options[:config] || '.scss-lint.yml'
      @config = if File.exist?(config_file)
                  SCSSLint::Config.load config_file
                else
                  SCSSLint::Config.default
                end

      @scss_lint_runner = SCSSLint::Runner.new @config
      @failed_paths     = []
    end

    def start
      Guard::Compat::UI.info "Guard::ScssLint (SCSSLint version #{SCSSLint::VERSION}) is running"
      run_all if @options[:all_on_start]
    end

    def reload
    end

    def run_all
      Guard::Compat::UI.info 'Running ScssLint for all .scss files'
      pattern = File.join '**', '*.scss'
      paths   = Guard::Compat.matching_files(self, Dir.glob(pattern))
      run_on_changes paths
    end

    def run_on_changes(paths)
      run paths.uniq
    end

    private

    def run(paths = [])
      @scss_lint_runner = SCSSLint::Runner.new @config
      paths = paths.reject { |p| @config.excluded_file?(p) }.map { |path| { path: path } }

      @scss_lint_runner.run paths
      @scss_lint_runner.lints.each do |lint|
        Guard::Compat::UI.send lint.severity, lint_message(lint)
      end

      lints = @scss_lint_runner.lints.count
      Guard::Compat::UI.info "Guard::ScssLint inspected #{paths.size} files, found #{lints} errors."
      Guard::Compat::UI.notify("#{lints} errors found",
                               title: 'Guard ScssLint issues found') if lints > 0
    end

    def lint_message(lint)
      [Rainbow(lint.filename).color(:cyan),
       ':',
       Rainbow(lint.location.line.to_s).color(:magenta),
       ':',
       Rainbow(lint.location.column.to_s).color(:blue),
       ' ',
       lint_severity_abbrevation(lint),
       ' ',
       Rainbow(lint.linter.name).color(:green),
       Rainbow(':').color(:green),
       ' ',
       lint.description
      ].join
    end

    def lint_severity_abbrevation(lint)
      color = lint.severity == :error ? :red : :yellow
      Rainbow(['[', lint.severity.to_s[0].upcase, ']'].join).color(color)
    end
  end
end
