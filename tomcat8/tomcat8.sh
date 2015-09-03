#!/bin/bash

export TOMCAT_MAJOR="8"
export TOMCAT_VERSION="8.0.26"
export TOMCAT_TGZ_URL="https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz"

export CATALINA_HOME="/var/lib/tomcat8"

mkdir -p $CATALINA_HOME
cd $CATALINA_HOME

curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
	&& tar -xf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz*

echo "export CATALINA_HOME=$CATALINA_HOME" >  $CATALINA_HOME/bin/setenv.sh
echo 'export CATALINA_OPTS="-Xms256m -Xmx768m "' >>  $CATALINA_HOME/bin/setenv.sh

chmod a+x $CATALINA_HOME/bin/setenv.sh

cat << _EOT_ > /etc/supervisor.d/tomcat8.conf
[program:tomcat8]
command=/var/lib/tomcat8/bin/catalina.sh run
redirect_stderr=true
stdout_logfile=/var/log/supervisor/tomcat8.log
_EOT_
