require "rails_helper"

describe ProjectHookParser do
  describe "Parser should transform hook to have the appropriate params" do
    before do
      @gitlab_project_hook_params = {
          "created_at" => "2012-07-21T07:30:54Z",
          "event_name" => "project_create",
          "name" => "StoreCloud",
          "owner_email" => "johnsmith@gmail.com",
          "owner_name" => "John Smith",
          "path" => "stormcloud",
          "path_with_namespace" => "jsmith/stormcloud",
          "id" => 74
      }

    end

    it "#to_param!" do
      hook = ProjectHookParser.new(@gitlab_project_hook_params)

      allow(hook).to receive(:add_ssh_http_info) { ["http://localhost/git/user/project.git", "git@localhost:user/project.git"] }

      expected_hash = {:name=>"StoreCloud", :gitproject_id=>74, :ssh_url_to_repo=>"http://localhost/git/user/project.git",
                       :http_url_to_repo=>"git@localhost:user/project.git"}
      generated_hash = hook.to_param!

      expect(generated_hash).to be_eql(expected_hash)
    end

    it "#add_ssh_http_info"
  end
end