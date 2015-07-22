require "rails_helper"

describe ProjectsHelper do
  describe "should return the last commit time of a project" do
    it "#last_commit_time" do
      #TODO: Change to use association
      project = FactoryGirl.create :project
      date_time = Time.zone.parse('2014-09-18 12:30:59')

      FactoryGirl.create :commit, commit_created_at: date_time, project_id: project.id

      expect(helper.last_commit_time(project).to_s).to be_eql date_time.to_s
    end
  end

  describe "should return the last author of a commit" do
    it "#last_commit_author" do
      #TODO: Change to use association
      project = FactoryGirl.create :project
      first_date_time = Time.zone.parse('2014-09-17 12:30:59')
      last_date_time = Time.zone.parse('2014-09-18 12:30:59')

      FactoryGirl.create :commit, commit_created_at: first_date_time, project_id: project.id, author_name: "Hugo"

      FactoryGirl.create :commit, commit_created_at: last_date_time, project_id: project.id, author_name: "Pri"

      expect(helper.last_commit_author(project)).to be_eql "Pri"
    end
  end
end