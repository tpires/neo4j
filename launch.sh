#!/bin/bash

NEO4J_HOME=/var/lib/neo4j
IPADDR=$(ip a s | sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')

sed -i "s|#org.neo4j.server.webserver.address=0.0.0.0|org.neo4j.server.webserver.address=$IPADDR|g" $NEO4J_HOME/conf/neo4j-server.properties
ulimit -n 65536 ; .$NEO4J_HOME/bin/neo4j console

