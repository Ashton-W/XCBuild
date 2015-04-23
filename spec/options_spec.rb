require 'spec_helper'

#
module XCBuild
  #
  describe Options do
    it 'has default filename' do
      expect(Options.yml_filename).to eq('.xcbuild.yml')
    end
  end
end
