set :stage, :staging
role :app, %w{ubuntu@172.31.18.45}
role :web, %w{ubuntu@172.31.18.45}
role :db, %w{ubuntu@172.31.18.45}

server '172.31.18.45', user: 'ubuntu', roles: %w{web app}