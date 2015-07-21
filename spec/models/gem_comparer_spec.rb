require "rails_helper"

describe GemComparer do

  describe "when the commits have the same version" do
    before do
      @array_of_commits_with_gems = [
          {"c0b920735042a8bc79704510b2e8e0ba020e0145" =>
               {"SyslogLogger" => "1.4.1"}},
          {"d79489b3eff1753b4b5b8822bc52adced4d5aa6a" =>
               {"SyslogLogger" => "1.4.1"}}
      ]
    end

    it "#compare_with_last should return equal" do
      last_commit = FactoryGirl.create :commit, hash_id: "c0b920735042a8bc79704510b2e8e0ba020e0145"
      first_commit = FactoryGirl.create :commit, hash_id: "d79489b3eff1753b4b5b8822bc52adced4d5aa6a"
      rubygem = FactoryGirl.create :rubygem, name: "SyslogLogger"
      gem_comparer = GemComparer.new(@array_of_commits_with_gems).compare_with_last(rubygem, "c0b920735042a8bc79704510b2e8e0ba020e0145")

      expect(gem_comparer).to be_eql("equal")
    end
  end

  describe "when the last commit has a newer version" do
    before do
      @array_of_commits_with_gems = [
          {"c0b920735042a8bc79704510b2e8e0ba020e0145" =>
               {"SyslogLogger" => "1.4.1"}},
          {"d79489b3eff1753b4b5b8822bc52adced4d5aa6a" =>
               {"SyslogLogger" => "1.4.0"}}
      ]
    end

    it "#compare_with_last should return up" do
      last_commit = FactoryGirl.create :commit, hash_id: "c0b920735042a8bc79704510b2e8e0ba020e0145"
      first_commit = FactoryGirl.create :commit, hash_id: "d79489b3eff1753b4b5b8822bc52adced4d5aa6a"
      rubygem = FactoryGirl.create :rubygem, name: "SyslogLogger"
      gem_comparer = GemComparer.new(@array_of_commits_with_gems).compare_with_last(rubygem, "c0b920735042a8bc79704510b2e8e0ba020e0145")

      expect(gem_comparer).to be_eql("up")
    end
    end

  describe "when the last commit has an older version" do
    before do
      @array_of_commits_with_gems = [
          {"c0b920735042a8bc79704510b2e8e0ba020e0145" =>
               {"SyslogLogger" => "1.4.0"}},
          {"d79489b3eff1753b4b5b8822bc52adced4d5aa6a" =>
               {"SyslogLogger" => "1.4.1"}}
      ]
    end

    it "#compare_with_last should return up" do
      last_commit = FactoryGirl.create :commit, hash_id: "c0b920735042a8bc79704510b2e8e0ba020e0145"
      first_commit = FactoryGirl.create :commit, hash_id: "d79489b3eff1753b4b5b8822bc52adced4d5aa6a"
      rubygem = FactoryGirl.create :rubygem, name: "SyslogLogger"
      gem_comparer = GemComparer.new(@array_of_commits_with_gems).compare_with_last(rubygem, "c0b920735042a8bc79704510b2e8e0ba020e0145")

      expect(gem_comparer).to be_eql("down")
    end
  end
end