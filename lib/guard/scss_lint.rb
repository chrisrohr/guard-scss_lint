require 'guard/compat/plugin'
require 'scss_lint'

require 'rainbow'
require 'rainbow/ext/string'

module Guard
  class ScssLint < Plugin

    attr_reader :options, :config

    def self.non_namespaced_name
      'scss_lint'
    end

    def initialize(options = {})
      super

      @options = {
        all_on_start: true
      }.merge(options)

      config_file = @options[:config] || '.scss-lint.yml'
      if File.exist?(config_file)
        @config = SCSSLint::Config.load config_file
      else
        @config = SCSSLint::Config.default
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
      paths = paths.reject { |p| @config.excluded_file?(p) }
      @scss_lint_runner.run paths
      @scss_lint_runner.lints.each do |lint|
        Guard::Compat::UI.send lint.severity, lint_message(lint)
      end
      Guard::Compat::UI.info "Guard::ScssLint inspected #{paths.size} files, found #{@scss_lint_runner.lints.count} errors."
      Guard::Compat::UI.notify("#{@scss_lint_runner.lints.count} errors found", title: "Guard ScssLint issues found") if @scss_lint_runner.lints.count > 0
    end

    def lint_message(lint)
      [lint.filename.color(:cyan),
       ':',
       lint.location.line.to_s.color(:magenta),
       ':',
       lint.location.column.to_s.color(:blue),
       ' ',
       lint_severity_abbrevation(lint),
       ' ',
       lint.linter.name.color(:green),
       ':'.color(:green),
       ' ',
       lint.description
      ].join
    end

    def lint_severity_abbrevation(lint)
      color = lint.severity == :error ? :red : :yellow
      ['[', lint.severity.to_s[0].upcase, ']'].join.color(color)
    end
  end
end
