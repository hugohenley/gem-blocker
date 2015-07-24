namespace :gemfile do
  namespace :import do
    # Import Gemfile and Commits of all projects in your Git Server
    desc "Gemfile Analyzer | Import projects, commits and gems!"
    task create: :environment do
      progress = ProgressBar.create( :format         => '%a %bᗧ%i %p%% %t',
                                     :progress_mark  => ' ',
                                     :remainder_mark => '･',
                                     :starting_at    => 0)

      100.times do
        sleep 1
        progress.increment
      end

    end

  end # namespace end: import
end # namespace end: gitlab
