require 'spec_helper'

#
module XCBuild
  #
  describe Options do
    def given_options(fixture)
      @options = Options.new("spec/fixture/#{fixture}.xcbuild.yml")
    end

    it 'has default filename' do
      expect(Options.default_yml_filename).to eq('.xcbuild.yml')
    end

    it 'loads options from file' do
      given_options :workspace_and_scheme
      expect(@options.yml).not_to be_nil
    end

    it 'has workspace and scheme config' do
      given_options :workspace_and_scheme
      expect(@options.workspace).to eq('Fixture.xcworkspace')
      expect(@options.scheme).to eq('Fixture')
    end
  end
end
