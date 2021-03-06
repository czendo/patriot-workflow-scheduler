require 'init_test'

describe Patriot::Tool::PatriotCommands::Upgrade do
  describe "help" do
    it "should show help" do
      args = ['help', 'upgrade']
      Patriot::Tool::PatriotCommand.start(args)
    end
  end

  describe "upgrade" do

    before :all do
      @config = File.join(ROOT_PATH, "spec", "config", "test.ini")
    end

    before :each do
      @controller = Patriot::Controller::PackageController.new(config_for_test)
      allow(Patriot::Controller::PackageController).to receive(:new).and_return(@controller)
    end

    it "install" do
      args = ['upgrade', "--config=#{@config}"]
      expect(@controller).to receive(:upgrade)
      expect{Patriot::Tool::PatriotCommand.start(args)}.not_to raise_error
    end

  end
end
