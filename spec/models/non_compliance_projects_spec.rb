require "rails_helper"

describe NonComplianceProjects do
  describe "#list" do
    it "should list the projects that are non compliance to the rules" do
      expected_return = { "project1": { "required": { "rails": "4.1.0", "json": "1.7.1" },
                                        "ifpresent": { "cancancan": "1.12.0" }, "denied": { "remarkable": "", "fakeweb": "" } } }
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

end