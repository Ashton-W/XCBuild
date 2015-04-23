require 'yaml'
require 'delegate'
require 'pathname'

# XCBuild
module XCBuild
  # xcodebuild options
  class Options < DelegateClass(Hash)
    attr_accessor :options, :project, :workspace, :target, :scheme
    attr_reader :loaded_path

    def initalize(hash = {}, loaded_path = nil)
      @hash = hash
      @loaded_path = loaded_path
      super(@hash)
    end

    def self.yml_filename
      '.xcbuild.yml'
    end

    def self.yml
      @yml ||= File.exist?(yml_filename) ? YAML.load_file(yml_filename) : {}
    end

    def configure_from_yml
      configure_project
      configure_workspace
      configure_target
      configure_scheme
    end

    def configure_project_from_yml
      self.project ||= self.class.yml['project'] if self.class.yml['project']
      self.project ||= Dir.glob('.xcodeproj').first
    end

    def configure_workspace_from_yml
      if self.class.yml['workspace']
        self.workspace ||= self.class.yml['workspace']
      end
      self.project ||= Dir.glob('.xcodeproj').first
    end

    def configure_target_from_yml
      self.target ||= self.class.yml['target'] if self.class.yml['target']
    end

    def configure_scheme_from_yml
      self.scheme ||= self.class.yml['scheme'] if self.class.yml['scheme']
    end
  end
end
