require 'yaml'
require 'xcodeproj'

# XCBuild
module XCBuild
  # xcodebuild options
  class Options
    attr_accessor :options, :project, :workspace, :target, :scheme
    attr_reader :yml_filename

    def initialize(yml_filename = nil)
      @yml_filename = yml_filename
      configure_from_yml if yml_filename
      infer_missing_options
    end

    def to_s
      ""
    end

    def self.default_yml_filename
      '.xcbuild.yml'
    end

    def yml_filename
      @yml_filename ||= self.class.default_yml_filename
    end

    def yml
      @yml ||= File.exist?(yml_filename) ? YAML.load_file(yml_filename) : {}
    end

    def configure_from_yml
      configure_project_from_yml
      configure_workspace_from_yml
      configure_target_from_yml
      configure_scheme_from_yml
    end

    def configure_project_from_yml
      @project ||= yml['project']
    end

    def configure_workspace_from_yml
      @workspace ||= yml['workspace']
    end

    def configure_target_from_yml
      @target ||= yml['target']
    end

    def configure_scheme_from_yml
      @scheme ||= yml['scheme']
    end

    def infer_missing_options
      infer_workspace unless workspace
      infer_scheme if workspace
      infer_project unless project || workspace
      infer_target if project
    end

    def infer_workspace
      workspace = Dir.glob('*.xcworkspace').first
      @workspace ||= workspace
    end

    def infer_project
      project = Dir.glob('*.xcodeproj').first
      @project ||= project
    end

    def infer_scheme
      workspace = Xcodeproj::Workspace.new_from_xcworkspace(@workspace)
      scheme = workspace.schemes.keys.first rescue return
      @scheme ||= scheme
    end

    def infer_target
      project = Xcodeproj::Project.open(@project)
      target = project.targets.keys.first rescue return
      @target ||= target
    end
  end
end
