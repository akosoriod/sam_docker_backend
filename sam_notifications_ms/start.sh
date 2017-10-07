eval $(docker-machine env rancher-node2)
docker-compose build
docker-compose run --rm sam_notifications_ms rake db:create
docker-compose run --rm sam_notifications_ms rake db:migrate
docker-compose run --rm sam_notifications_ms rake db:seed
docker-compose run --rm sam_notifications_ms bundle exec rpush init
docker-compose up
