require "rails_helper"

describe Commit do

  describe "given commits are saved from the last commited to first" do
    describe '#next' do
      it "returns the last commit (first created on database) when call next on the first commit" do
        @last_commit = FactoryGirl.create :commit
        @first_commit = FactoryGirl.create :commit

        expect(@first_commit.next.id).to equal(@last_commit.id)
      end

      it "returns the last commit (having 3 commits on database)" do
        @last_commit = FactoryGirl.create :commit
        @some_commit = FactoryGirl.create :commit
        @first_commit = FactoryGirl.create :commit

        expect(@some_commit.next.id).to equal(@last_commit.id)
        expect(@first_commit.next.id).to equal(@some_commit.id)
      end

      it "returns nil if there is no next commit" do
        @first_commit = FactoryGirl.create :commit

        expect(@first_commit.next).to be_nil
      end
    end

    describe "#previous" do
      it "returns the previous commit when call previous on the last commit" do
        @last_commit = FactoryGirl.create :commit
        @first_commit = FactoryGirl.create :commit

        expect(@last_commit.previous.id).to equal(@first_commit.id)
      end

      it "returns the previous commit (having 3 commits on database)" do
        @last_commit = FactoryGirl.create :commit
        @some_commit = FactoryGirl.create :commit
        @first_commit = FactoryGirl.create :commit

        expect(@last_commit.previous.id).to equal(@some_commit.id)
        expect(@some_commit.previous.id).to equal(@first_commit.id)
      end

      it "returns nil if there is no previous commit" do
        @first_commit = FactoryGirl.create :commit

        expect(@first_commit.previous).to be_nil
      end
    end

  end

end