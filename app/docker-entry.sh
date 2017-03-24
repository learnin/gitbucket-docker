#!/bin/bash

cat > /gitbucket/database.conf <<-EOCONF
db {
  url = "jdbc:mysql://$GITBUCKET_DB_HOST/$GITBUCKET_DB_NAME?useUnicode=true&characterEncoding=utf8"
  user = "$GITBUCKET_DB_USER"
  password = "$GITBUCKET_DB_PASSWORD"
}
EOCONF

echo "Wait until database $GITBUCKET_DB_HOST:3306 is ready..."
until nc -z $GITBUCKET_DB_HOST 3306
do
    sleep 1
done

# Wait to avoid "panic: Failed to open sql connection pq: the database system is starting up"
sleep 1

echo "Starting gitbucket app"
exec java $JAVA_OPTS -jar /opt/gitbucket.war $GITBUCKET_OPTS
