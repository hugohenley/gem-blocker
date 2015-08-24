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
    it "should list the projects that are non compliance to the required rules, one per project" do
      project = FactoryGirl.create :project, name: "Project 1"
      commit = FactoryGirl.create :commit, hash_id: "d179866018c21022006f10061a6db74fe18860ce", project: project
      FactoryGirl.create :used_gem, name: "rails", version: "4.1.0", commit: commit
      FactoryGirl.create :used_gem, name: "json", version: "1.7.6", commit: commit

      project2 = FactoryGirl.create :project, name: "Project 2"
      commit2 = FactoryGirl.create :commit, hash_id: "e179866018c219823306f10061a6db74fe18860ce", project: project2
      FactoryGirl.create :used_gem, name: "rails", version: "4.0.9", commit: commit2
      FactoryGirl.create :used_gem, name: "json", version: "1.7.7", commit: commit2
      FactoryGirl.create :used_gem, name: "newrelic_rpm", version: "3.9.2222", commit: commit2

      expected_return = [{"Project 1"=>[{:required=>{"json"=>"1.7.6"}},
                                        {:not_present=>{"newrelic_rpm"=>["3.9.2222"]}},
                                        {:allow_if_present=>{}}, {:deny=>{}}]},
                         {"Project 2"=>[{:required=>{"rails"=>"4.0.9"}},
                                        {:not_present=>{}}, {:allow_if_present=>{}}, {:deny=>{}}]}]

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


      expected_return = [{"Project 1"=>[{:required=>{"rails"=>"4.0.9", "json"=>"1.7.6"}},
                                        {:not_present=>{"newrelic_rpm"=>["3.9.2222"]}},
                                        {:allow_if_present=>{}}, {:deny=>{}}]},
                         {"Project 2"=>[{:required=>{"rails"=>"4.2.1", "json"=>"1.7.8"}},
                                        {:not_present=>{"newrelic_rpm"=>["3.9.2222"]}},
                                        {:allow_if_present=>{}}, {:deny=>{}}]}]

      expect(NonComplianceProjects.new.list).to be_eql expected_return
    end

    it "should list the projects that are non compliance to the required rules, two per project, more than one version on required gem" do
      gemblocker4 = FactoryGirl.create :gemblocker, gem: "twitter", verification_type: "Required"
      FactoryGirl.create :blockedversion, number: "2.0", gemblocker: gemblocker4
      FactoryGirl.create :blockedversion, number: "2.1", gemblocker: gemblocker4

      project = FactoryGirl.create :project, name: "Project 1"
      commit = FactoryGirl.create :commit, hash_id: "d179866018c21022006f10061a6db74fe18860ce", project: project
      FactoryGirl.create :used_gem, name: "rails", version: "4.0.9", commit: commit
      FactoryGirl.create :used_gem, name: "json", version: "1.7.6", commit: commit
      FactoryGirl.create :used_gem, name: "newrelic_rpm", version: "3.9.2222", commit: commit

      project2 = FactoryGirl.create :project, name: "Project 2"
      commit2 = FactoryGirl.create :commit, hash_id: "e179866018c219823306f10061a6db74fe18860ce", project: project2
      FactoryGirl.create :used_gem, name: "rails", version: "4.2.1", commit: commit2
      FactoryGirl.create :used_gem, name: "json", version: "1.7.8", commit: commit2
      FactoryGirl.create :used_gem, name: "newrelic_rpm", version: "3.9.2222", commit: commit2


      expected_return = [{"Project 1"=>[{:required=>{"rails"=>"4.0.9", "json"=>"1.7.6"}},
                                         {:not_present => {"twitter" => ["2.0", "2.1"]}},
                                        {:allow_if_present=>{}}, {:deny=>{}}]},
                         {"Project 2"=>[{:required=>{"rails"=>"4.2.1", "json"=>"1.7.8"}},
                                         {:not_present => {"twitter" => ["2.0", "2.1"]}},
                                        {:allow_if_present=>{}}, {:deny=>{}}]}]

      expect(NonComplianceProjects.new.list).to be_eql expected_return
    end
  end
end