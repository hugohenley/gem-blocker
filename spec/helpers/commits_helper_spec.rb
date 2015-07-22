require "rails_helper"

describe CommitsHelper do
  describe "should print the right image" do
    it "when the new commit has the same version of the last commit" do
      used_gem = FactoryGirl.build :used_gem, diff: "equal"

      expect(helper.print_delta(used_gem)).to be_eql("<img src=\"/assets/equal.png\" alt=\"Equal\" />")
    end

    it "when the new commit has a newer version" do
      used_gem = FactoryGirl.build :used_gem, diff: "up"

      expect(helper.print_delta(used_gem)).to be_eql("<img src=\"/assets/arrow_up.png\" alt=\"Arrow up\" />")
    end

    it "when the new commit has a lower version" do
      used_gem = FactoryGirl.build :used_gem, diff: "down"

      expect(helper.print_delta(used_gem)).to be_eql("<img src=\"/assets/arrow_down.png\" alt=\"Arrow down\" />")
    end

  end
end