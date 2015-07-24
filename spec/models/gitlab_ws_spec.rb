require "rails_helper"

describe GitlabServer do
  it { is_expected.to respond_to(:project_info) }

  it { is_expected.to respond_to(:all_projects_info) }

  it { is_expected.to respond_to(:project_commits) }

  it { is_expected.to respond_to(:raw_gemfilelock) }
end