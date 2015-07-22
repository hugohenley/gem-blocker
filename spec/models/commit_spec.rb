require "rails_helper"

describe Commit do

  describe "associations" do
    it { is_expected.to have_many(:used_gems) }
  end

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

  describe "if the commit was already imported" do
    before do
      @commit = {"id" => "d179866018c21022006f10061a6db74fe18860ce",
                 "short_id" => "d179866018c", "title" => "CLOSES #1: Title of the commit",
                 "author_name" => "Hugo Henley", "author_email" => "hugohenley@example.com",
                 "created_at" => "2015-05-21T17:28:53-03:00"}
      FactoryGirl.create :commit, hash_id: "d179866018c21022006f10061a6db74fe18860ce"
    end
    it ".already_imported? must be true" do
      expect(Commit.already_imported?(@commit)).to be true
    end
  end

  describe "if the commit was not imported" do
    before do
      @commit = {"id" => "d179866018c21022006f10061a6db74fe18860ce",
                 "short_id" => "d179866018c", "title" => "CLOSES #1: Title of the commit",
                 "author_name" => "Hugo Henley", "author_email" => "hugohenley@example.com",
                 "created_at" => "2015-05-21T17:28:53-03:00"}
      FactoryGirl.create :commit, hash_id: "6a47a96db589f852330cb3755f57025e5a38382d"
    end
    it ".already_imported? must be false" do
      expect(Commit.already_imported?(@commit)).to be false
    end
  end


end