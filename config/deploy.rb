# Define the name of the application
set :application, 'papersummarize'

# Define where can Capistrano access the source repository
# set :repo_url, 'https://github.com/[user name]/[application name].git'
set :repo_url, 'https://github.com/mrdrozdov/papersummarize.git'

# Define where to put your application code
set :deploy_to, "/home/deploy/www/papersummarize"

set :pty, true

set :format, :pretty

# Set the post-deployment instructions here.
# Once the deployment is complete, Capistrano
# will begin performing them as described.
# To learn more about creating tasks,
# check out:
# http://capistranorb.com/

# namespace: deploy do

desc 'Launch application'
task :launch do
  on roles(:app), in: :sequence do
    execute "bash /home/deploy/server/papersummarize/scripts/launch.sh ~/.venv ~/www/papersummarize/current ~/server/papersummarize"
  end
end

desc 'Stop application'
task :stop do
  on roles(:app), in: :sequence do
    execute "bash /home/deploy/server/papersummarize/scripts/stop.sh ~/.venv ~/www/papersummarize/current ~/server/papersummarize"
  end
end

desc 'Fetch papers'
task :fetch do
  on roles(:app), in: :sequence do
    execute "bash /home/deploy/server/papersummarize/scripts/fetch_papers.sh ~/.venv-arxiv ~/arxiv-sanity-preserver ~/server/papersummarize/db.pkl2"
  end
end

desc 'Load papers'
task :load_papers do
  on roles(:app), in: :sequence do
    execute "bash /home/deploy/server/papersummarize/scripts/load_papers.sh ~/.venv ~/www/papersummarize/current"
  end
end

namespace :deploy do
  after :finishing, :notify do
    on roles(:app), in: :sequence do
      execute "bash /home/deploy/server/papersummarize/scripts/install.sh ~/.venv ~/www/papersummarize/current"
    end
  end
end

#   after :publishing, :restart

#   after :restart, :clear_cache do
#     on roles(:web), in: :groups, limit: 3, wait: 10 do
#       # Here we can do anything such as:
#       # within release_path do
#       #   execute :rake, 'cache:clear'
#       # end
#     end
#   end

# end