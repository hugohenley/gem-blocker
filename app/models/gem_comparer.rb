class GemComparer

  attr_reader :git_project_id, :array_of_commits

  def initialize(git_project_id, array_of_commits)
    @git_project_id = git_project_id
    @array_of_commits = array_of_commits
  end

  def compare_with_last(rubygem, commit_id)
    array_of_commit_hashs = @array_of_commits
    actual_commit = array_of_commit_hashs.detect {|key| key[commit_id]}
    actual_index = array_of_commit_hashs.index {|key| key[commit_id] }
    previous_index = actual_index + 1
    previous_commit = array_of_commit_hashs[previous_index]
    return if previous_commit.nil?

    previous_commit_id = previous_commit.keys[0]
    current_version = actual_commit[commit_id][rubygem.name]
    last_version = previous_commit[previous_commit_id][rubygem.name]
    self.delta(current_version, last_version)
  end

  def delta(current_version, last_version)
    if Gem::Version.new(current_version) < Gem::Version.new(last_version)
      "down"
    elsif Gem::Version.new(current_version) == Gem::Version.new(last_version)
      "equal"
    else
      "up"
    end
  end


end