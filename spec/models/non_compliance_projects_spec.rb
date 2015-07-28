require "rails_helper"

describe NonComplianceProjects do
  before do
    gemblocker = FactoryGirl.create :gemblocker, gem: "rails", verification_type: "Required"
    FactoryGirl.create :blockedversion, number: "4.1.0", gemblocker: gemblocker
    FactoryGirl.create :blockedversion, number: "4.2.3", gemblocker: gemblocker

    gemblocker2 = FactoryGirl.create :gemblocker, gem: "json", verification_type: "Required"
    FactoryGirl.create :blockedversion, number: "1.7.7", gemblocker: gemblocker2

    gemblocker3 = FactoryGirl.create :gemblocker, gem: "newrelic_rpm", verification_type: "Required"
    FactoryGirl.create :blockedversion, number: "3.9.2222", gemblocker: gemblocker3
  end

  describe "#list" do
    it "should list the projects that are non compliance to the rules" do
      expected_return = { "project1": { "required": { "rails": "4.1.0", "json": "1.7.1" },
                                        "ifpresent": { "cancancan": "1.12.0" }, "denied": { "remarkable": "", "fakeweb": "" } } }
    end

    it "should list the projects that are non compliance to the required rules, one per project" do
      project = FactoryGirl.create :project, name: "Project 1"
      commit = FactoryGirl.create :commit, hash_id: "d179866018c21022006f10061a6db74fe18860ce", project: project
      FactoryGirl.create :used_gem, name: "rails", version: "4.1.0", commit: commit
      FactoryGirl.create :used_gem, name: "json", version: "1.7.6", commit: commit

      project2 = FactoryGirl.create :project, name: "Project 2"
      commit2 = FactoryGirl.create :commit, hash_id: "e179866018c219823306f10061a6db74fe18860ce", project: project2
      FactoryGirl.create :used_gem, name: "rails", version: "4.0.9", commit: commit2
      FactoryGirl.create :used_gem, name: "json", version: "1.7.7", commit: commit2

      expected_return = [{"Project 1"=>[{:required=>{"json"=>"1.7.6"}}]}, {"Project 2"=>[{:required=>{"rails"=>"4.0.9"}}]}]

      expect(NonComplianceProjects.new.list).to be_eql expected_return
    end

    it "should list the projects that are non compliance to the required rules, two per project" do
      project = FactoryGirl.create :project, name: "Project 1"
      commit = FactoryGirl.create :commit, hash_id: "d179866018c21022006f10061a6db74fe18860ce", project: project
      FactoryGirl.create :used_gem, name: "rails", version: "4.0.9", commit: commit
      FactoryGirl.create :used_gem, name: "json", version: "1.7.6", commit: commit

      project2 = FactoryGirl.create :project, name: "Project 2"
      commit2 = FactoryGirl.create :commit, hash_id: "e179866018c219823306f10061a6db74fe18860ce", project: project2
      FactoryGirl.create :used_gem, name: "rails", version: "4.2.1", commit: commit2
      FactoryGirl.create :used_gem, name: "json", version: "1.7.8", commit: commit2


      expected_return = [{"Project 1"=>[{:required=>{"rails"=>"4.0.9", "json"=>"1.7.6"}}]},
                         {"Project 2"=>[{:required=>{"rails"=>"4.2.1", "json"=>"1.7.8"}}]}]

      expect(NonComplianceProjects.new.list).to be_eql expected_return
    end
  end

  describe "#last_used_gems_of" do
    it "should return nil if there are no commits" do
      project = FactoryGirl.create :project, name: "Project 1"
      expect(NonComplianceProjects.new.last_used_gems_of project).to be nil
    end

    it "should return the list of gems used in the last commit" do
      project = FactoryGirl.create :project, name: "Project 1"
      commit = FactoryGirl.create :commit, hash_id: "d179866018c21022006f10061a6db74fe18860ce", project: project
      FactoryGirl.create :used_gem, name: "rails", version: "4.1.2", commit: commit
      FactoryGirl.create :used_gem, name: "json", version: "1.7.7", commit: commit
      FactoryGirl.create :used_gem, name: "newrelic_rpm", version: "3.12.0.288", commit: commit
      FactoryGirl.create :used_gem, name: "rake", version: "10.4.2", commit: commit

      expected_hash = {"rails"=>"4.1.2", "json"=>"1.7.7", "newrelic_rpm"=>"3.12.0.288", "rake"=>"10.4.2"}

      expect(NonComplianceProjects.new.last_used_gems_of project).to be_eql expected_hash
    end
  end

  describe "#verify_required_gems" do
    before do
      gemblocker = FactoryGirl.create :gemblocker, gem: "rails", verification_type: "Required"
      FactoryGirl.create :blockedversion, number: "4.1.0", gemblocker: gemblocker
      FactoryGirl.create :blockedversion, number: "4.2.3", gemblocker: gemblocker

      gemblocker2 = FactoryGirl.create :gemblocker, gem: "json", verification_type: "Required"
      FactoryGirl.create :blockedversion, number: "1.7.7", gemblocker: gemblocker2

      gemblocker3 = FactoryGirl.create :gemblocker, gem: "newrelic_rpm", verification_type: "Required"
      FactoryGirl.create :blockedversion, number: "3.9.2222", gemblocker: gemblocker3
    end

    it "should return the required gems for a given hash of used gems" do
      used_gems = {"rails"=>"4.1.2", "json"=>"1.7.7", "newrelic_rpm"=>"3.12.0.288", "rake"=>"10.4.2"}
      expected_hash = {:required=>{"rails"=>"4.1.2", "newrelic_rpm"=>"3.12.0.288"}}

      expect(NonComplianceProjects.new.verify_required_gems(used_gems)).to be_eql expected_hash
    end
  end

end