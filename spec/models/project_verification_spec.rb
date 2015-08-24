require "rails_helper"

describe ProjectVerification do
  before do
    gemblocker = FactoryGirl.create :gemblocker, gem: "rails", verification_type: "Required"
    FactoryGirl.create :blockedversion, number: "4.1.0", gemblocker: gemblocker
    FactoryGirl.create :blockedversion, number: "4.2.3", gemblocker: gemblocker

    gemblocker2 = FactoryGirl.create :gemblocker, gem: "json", verification_type: "Required"
    FactoryGirl.create :blockedversion, number: "1.7.7", gemblocker: gemblocker2

    gemblocker3 = FactoryGirl.create :gemblocker, gem: "newrelic_rpm", verification_type: "Required"
    FactoryGirl.create :blockedversion, number: "3.9.2222", gemblocker: gemblocker3
  end

  describe "#last_used_gems_of" do
    it "should return nil if there are no commits" do
      project = FactoryGirl.create :project, name: "Project 1"
      expect(ProjectVerification.new.last_used_gems_of project).to be nil
    end

    it "should return the list of gems used in the last commit" do
      project = FactoryGirl.create :project, name: "Project 1"
      commit = FactoryGirl.create :commit, hash_id: "d179866018c21022006f10061a6db74fe18860ce", project: project
      FactoryGirl.create :used_gem, name: "rails", version: "4.1.2", commit: commit
      FactoryGirl.create :used_gem, name: "json", version: "1.7.7", commit: commit
      FactoryGirl.create :used_gem, name: "newrelic_rpm", version: "3.12.0.288", commit: commit
      FactoryGirl.create :used_gem, name: "rake", version: "10.4.2", commit: commit

      expected_hash = {"rails"=>"4.1.2", "json"=>"1.7.7", "newrelic_rpm"=>"3.12.0.288", "rake"=>"10.4.2"}

      expect(ProjectVerification.new.last_used_gems_of project).to be_eql expected_hash
    end
  end

  describe "#verify_locked_gems" do
    describe "when the type of lock is required" do
      before do
        gemblocker = FactoryGirl.create :gemblocker, gem: "rails", verification_type: "Required"
        FactoryGirl.create :blockedversion, number: "4.1.0", gemblocker: gemblocker
        FactoryGirl.create :blockedversion, number: "4.2.3", gemblocker: gemblocker

        gemblocker2 = FactoryGirl.create :gemblocker, gem: "json", verification_type: "Required"
        FactoryGirl.create :blockedversion, number: "1.7.7", gemblocker: gemblocker2

        gemblocker3 = FactoryGirl.create :gemblocker, gem: "newrelic_rpm", verification_type: "Required"
        FactoryGirl.create :blockedversion, number: "3.9.2222", gemblocker: gemblocker3

        gemblocker4 = FactoryGirl.create :gemblocker, gem: "twitter", verification_type: "Required"
        FactoryGirl.create :blockedversion, number: "2.1", gemblocker: gemblocker4
      end

      it "should return the required gems for a given hash of used gems" do
        used_gems = {"rails"=>"4.1.2", "json"=>"1.7.7", "newrelic_rpm"=>"3.12.0.288", "rake"=>"10.4.2"}
        expected_hash = {:required=>{"rails"=>"4.1.2", "newrelic_rpm"=>"3.12.0.288"}}

        expect(ProjectVerification.new.verify_locked_gems(used_gems, :required)).to be_eql expected_hash
      end

      it "should return nil if all the required gems are compliance" do
        used_gems = {"rails"=>"4.2.3", "json"=>"1.7.7", "newrelic_rpm"=>"3.9.2222", "rake"=>"10.4.2", "twitter" => "2.1"}
        expected_hash = {:required=>{}}

        expect(ProjectVerification.new.verify_locked_gems(used_gems, :required)).to be_eql expected_hash
      end
    end

    describe "when the type of lock is deny" do
      before do
        gemblocker = FactoryGirl.create :gemblocker, gem: "rails", verification_type: "Deny"
        FactoryGirl.create :blockedversion, number: "4.1.0", gemblocker: gemblocker
        FactoryGirl.create :blockedversion, number: "4.2.3", gemblocker: gemblocker

        gemblocker2 = FactoryGirl.create :gemblocker, gem: "json", verification_type: "Deny"
        FactoryGirl.create :blockedversion, number: "1.7.7", gemblocker: gemblocker2

        gemblocker3 = FactoryGirl.create :gemblocker, gem: "newrelic_rpm", verification_type: "Deny"
        FactoryGirl.create :blockedversion, number: "3.9.2222", gemblocker: gemblocker3
      end

      it "should return the denied gems for a given hash of used gems" do
        used_gems = {"rails"=>"4.1.2", "json"=>"1.7.7", "newrelic_rpm"=>"3.12.0.288", "rake"=>"10.4.2"}
        expected_hash = {:deny=>{"json"=>"1.7.7"}}

        expect(ProjectVerification.new.verify_locked_gems(used_gems, :deny)).to be_eql expected_hash
      end

      it "should return nil if all the present gems are compliance" do
        used_gems = {"rails"=>"4.2.2", "json"=>"1.7.6", "newrelic_rpm"=>"3.9.2221", "rake"=>"10.4.2"}
        expected_hash = {:deny=>{}}

        expect(ProjectVerification.new.verify_locked_gems(used_gems, :deny)).to be_eql expected_hash
      end
    end

    describe "when the type of lock is allow if present" do
      before do
        gemblocker = FactoryGirl.create :gemblocker, gem: "rails", verification_type: "Allow If Present"
        FactoryGirl.create :blockedversion, number: "4.1.0", gemblocker: gemblocker
        FactoryGirl.create :blockedversion, number: "4.2.3", gemblocker: gemblocker

        gemblocker2 = FactoryGirl.create :gemblocker, gem: "json", verification_type: "Allow If Present"
        FactoryGirl.create :blockedversion, number: "1.7.7", gemblocker: gemblocker2

        gemblocker3 = FactoryGirl.create :gemblocker, gem: "newrelic_rpm", verification_type: "Allow If Present"
        FactoryGirl.create :blockedversion, number: "3.9.2222", gemblocker: gemblocker3
      end

      it "should return the required gems for a given hash of used gems" do
        used_gems = {"rails"=>"4.1.2", "json"=>"1.7.7", "newrelic_rpm"=>"3.12.0.288", "rake"=>"10.4.2"}
        expected_hash = {:allow_if_present=>{"rails"=>"4.1.2", "newrelic_rpm"=>"3.12.0.288"}}

        expect(ProjectVerification.new.verify_locked_gems(used_gems, :allow_if_present)).to be_eql expected_hash
      end

      it "should return nil if all the present gems are compliance" do
        used_gems = {"rails"=>"4.2.3", "json"=>"1.7.7", "newrelic_rpm"=>"3.9.2222", "rake"=>"10.4.2"}
        expected_hash = {:allow_if_present=>{}}

        expect(ProjectVerification.new.verify_locked_gems(used_gems, :allow_if_present)).to be_eql expected_hash
      end
    end
  end


end