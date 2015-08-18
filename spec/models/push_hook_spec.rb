require 'rails_helper'

describe PushHook do
  describe '#save!' do
    before do
      @params = {
          "before": "95790bf891e76fee5e1747ab589903a6a1f80f22",
          "after": "da1560886d4f094c3e6c9ef40349f7d38b5d27d7",
          "ref": "refs/heads/master",
          "user_id": 4,
          "user_name": "John Smith",
          "user_email": "john@example.com",
          "project_id": 15,
          "repository": {
              "name": "Diaspora",
              "url": "git@localhost:diaspora.git",
              "description": "",
              "homepage": "http://localhost/diaspora"
          },

          "commits": [
              {
                  "id": "b6568db1bc1dcd7f8b4d5a946b0b91f9dacd7327",
                  "message": "Update Catalan translation to e38cb41.",
                  "timestamp": "2011-12-12T14:27:31+02:00",
                  "url": "http://localhost/diaspora/commits/b6568db1bc1dcd7f8b4d5a946b0b91f9dacd7327",
                  "author": {
                      "name": "Jordi Mallach",
                      "email": "jordi@softcatala.org"
                  }
              },

              {
                  "id": "da1560886d4f094c3e6c9ef40349f7d38b5d27d7",
                  "message": "fixed readme",
                  "timestamp": "2012-01-03T23:36:29+02:00",
                  "url": "http://localhost/diaspora/commits/da1560886d4f094c3e6c9ef40349f7d38b5d27d7",
                  "author": {
                      "name": "GitLab dev user",
                      "email": "gitlabdev@dv6700.(none)"
                  }
              }
          ],
          "total_commits_count": 4
      }

      @project = FactoryGirl.create :project, gitproject_id: 15
    end
    it 'should save the commits sent on push' do
      push = PushHook.new(@params)
      gemimporter = double('gemimporter')
      allow(GemImporter).to receive(:new).and_return(gemimporter)
      allow(gemimporter).to receive(:import).and_return(true)
      push.save!

      expect(Commit.count).to be 2
    end

    it 'should save details for each commit' do
      push = PushHook.new(@params)
      gemimporter = double('gemimporter')
      allow(GemImporter).to receive(:new).and_return(gemimporter)
      allow(gemimporter).to receive(:import).and_return(true)
      push.save!

      first_commit = Commit.first
      last_commit = Commit.last
      expect(first_commit.author_name).to be_eql "Jordi Mallach"
      expect(first_commit.author_email).to be_eql "jordi@softcatala.org"
      expect(first_commit.project_id).to be_eql @project.id
      expect(first_commit.hash_id).to be_eql "b6568db1bc1dcd7f8b4d5a946b0b91f9dacd7327"
      expect(first_commit.commit_created_at.to_s).to be_eql "2011-12-12 12:27:31 UTC"
      expect(first_commit.title).to be_eql "Update Catalan translation to e38cb41."

      expect(last_commit.author_name).to be_eql "GitLab dev user"
      expect(last_commit.author_email).to be_eql "gitlabdev@dv6700.(none)"
      expect(last_commit.project_id).to be_eql @project.id
      expect(last_commit.hash_id).to be_eql "da1560886d4f094c3e6c9ef40349f7d38b5d27d7"
      expect(last_commit.commit_created_at.to_s).to be_eql "2012-01-03 21:36:29 UTC"
      expect(last_commit.title).to be_eql "fixed readme"


    end
  end
end