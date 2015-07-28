namespace :gemfile do
  namespace :import do
    # Import Gemfile and Commits of all projects in your Git Server
    desc "Gemfile Analyzer | Import projects, commits and gems!"
    task create: :environment do
      puts "The operation below can take some minutes depending on the number of Projects, Commits and Gems that
      are being used in your organization. Maybe it's time to make some coffee... (◕‿◕)".colorize(:light_blue)

      puts "
           .\"\"\"-.
          /      \\
          |  _..--'-.
          >.`__.-"";\"`
         / /(     ^\\
         '-`)     =|-.
          /`--.'--'   \\ .-.
          .'`-._ `.\\    | J /
     /      `--.|   \\__/
".green

      sync = Sync.new

      puts "Importing Projects".red
      initialize_progress(sync.count_projects)
      sync.import_projects
      puts "Projects were imported with success.\n\n".green

      puts "Importing Commits".red
      initialize_progress(sync.count_projects)
      sync.import_commits
      puts "Commits were imported with success.\n\n".green

      puts "Importing Gems".red
      initialize_progress(Commit.count)
      sync.import_gems
      puts "Gems were imported with success.\n\n".green

    end

    def initialize_progress(total)
      $progress = ProgressBar.create(:format => '%a %bᗧ%i %p%% %t',
                                     :progress_mark => ' ',
                                     :remainder_mark => '･'.green,
                                     :starting_at => 0,
                                     :total => total)
    end

  end
end
