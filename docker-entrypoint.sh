#!/bin/sh
set -e
PORT="${PORT:-8080}"
sed -i "s/Connector port=\"8080\"/Connector port=\"${PORT}\"/" /usr/local/tomcat/conf/server.xml
export JAVA_OPTS="${JAVA_OPTS} -Djava.net.preferIPv4Stack=true"
exec catalina.sh run
