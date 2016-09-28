set :stage, :staging
role :app, %w{ubuntu@172.31.25.118}
role :web, %w{ubuntu@172.31.25.118}
role :db, %w{ubuntu@172.31.25.118}

server '172.31.25.118', user: 'ubuntu', roles: %w{web app}