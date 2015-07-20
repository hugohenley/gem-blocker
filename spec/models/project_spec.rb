require "rails_helper"

describe Project do

  describe '.already_imported?' do
    describe "based on gitlab project id" do
      before do
        @gitlab_incoming_hash = {"id"=>117, "description"=>"Description goes here.", "default_branch"=>"master", "public"=>false,
                                 "visibility_level"=>10, "ssh_url_to_repo"=>"git@localhost:user/project_name.git",
                                 "http_url_to_repo"=>"http://localhostproject_name/git/user/project_name.git",
                                 "web_url"=>"http://localhostproject_name/git/user/project_name",
                                 "owner"=>{"id"=>56, "username"=>"user", "email"=>"morton@beahan.org",
                                           "name"=>"Austyn Gutkowski", "state"=>"active", "created_at"=>"2014-12-04T20:16:21.309Z"},
                                 "name"=>"project_name", "name_with_namespace"=>"Austyn Gutkowski / project_name", "path"=>"project_name",
                                 "path_with_namespace"=>"user/project_name", "issues_enabled"=>true, "merge_requests_enabled"=>true,
                                 "wall_enabled"=>false, "wiki_enabled"=>true, "snippets_enabled"=>false,
                                 "created_at"=>"2015-04-13T19:36:29.509Z", "last_activity_at"=>"2015-05-21T20:29:08.746Z",
                                 "namespace"=>{"id"=>59, "name"=>"user", "path"=>"user", "owner_id"=>56, "created_at"=>"2014-12-04T20:16:21.324Z",
                                               "updated_at"=>"2014-12-04T20:16:21.324Z", "description"=>"", "avatar"=>nil}}

      end

      it "returns true if project already exists on database" do
        @project = FactoryGirl.create :project, gitlab_id: 117

        expect(Project.already_imported?(@gitlab_incoming_hash)).to be true
      end

      it "returns false if project does not exit on database" do
        @project = FactoryGirl.create :project, gitlab_id: 118

        expect(Project.already_imported?(@gitlab_incoming_hash)).to be false
      end
    end


  end

end