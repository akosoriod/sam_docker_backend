eval $(docker-machine env rancher-node2)
docker-compose build
curl -X PUT http://admin:admin@192.168.99.101:5984/scheduledsending
curl -X POST http://admin:admin@192.168.99.101:5984/scheduledsending/ -H "Content-Type: application/json" -d '{"_id":"_design/all_sheduledsending","views":{"all": {"map": "function (doc) {\n  emit(doc._id, {user_id:doc.user_id,mail_id:doc.mail_id,date:doc.date,rev:doc._rev});\n}"}},"language":"javascript"}'
docker-compose up
