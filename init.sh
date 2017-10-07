sudo service docker start
docker-machine start rancher-server
sleep 2
docker-machine start rancher-node2
sleep 2
eval $(docker-machine env rancher-node2)
cd sam_api_gateway
docker-compose up -d
cd ../sam_sessions_ms
docker-compose up -d
cd ../sam_register_ms
docker-compose up -d
cd ..
