## Neo4J dependency: dockerfile/java
## get java from trusted build
from dockerfile/java
maintainer Tiago Pires, tandrepires@gmail.com

## install neo4j according to http://www.neo4j.org/download/linux
# Import neo4j signing key
# Create an apt sources.list file
# Find out about the files in neo4j repo ; install neo4j community edition

run wget -O - http://debian.neo4j.org/neotechnology.gpg.key | apt-key add - && \
    echo 'deb http://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list && \
    apt-get update ; apt-get install neo4j -y

## add launcher and set execute property
## clean sources
## turn on indexing: http://chrislarson.me/blog/install-neo4j-graph-database-ubuntu
## enable neo4j indexing, and set indexable keys to name,age
# enable shell server on all network interfaces

add launch.sh /
run chmod +x /launch.sh && \
    apt-get clean && \
    sed -i "s|#node_auto_indexing|node_auto_indexing|g" /var/lib/neo4j/conf/neo4j.properties && \
    sed -i "s|#node_keys_indexable|node_keys_indexable|g" /var/lib/neo4j/conf/neo4j.properties && \ 
    echo "remote_shell_host=0.0.0.0" >> /var/lib/neo4j/conf/neo4j.properties && \
    printf "wrapper.java.initmemory=4096\nwrapper.java.maxmemory=4096\n" >> /var/lib/neo4j/conf/neo4j-wrapper.conf && \
    printf "neostore.nodestore.db.mapped_memory=50M\nneostore.relationshipstore.db.mapped_memory=500M\nneostore.propertystore.db.mapped_memory=100M\nneostore.propertystore.db.strings.mapped_memory=100M\nneostore.propertystore.db.arrays.mapped_memory=0M" >> /var/lib/neo4j/conf/neo4j.properties

# expose REST and shell server ports
expose 7474
expose 1337

workdir /

## entrypoint
cmd ["/bin/bash", "-c", "/launch.sh"]
