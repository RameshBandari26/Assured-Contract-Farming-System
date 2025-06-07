FROM openjdk:21-jdk

ENV TOMCAT_VERSION=9.0.75
ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH

RUN apt-get update && apt-get install -y wget curl \
    && wget https://dlcdn.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
    && mkdir -p $CATALINA_HOME \
    && tar xzf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C $CATALINA_HOME --strip-components=1 \
    && rm apache-tomcat-${TOMCAT_VERSION}.tar.gz \
    && apt-get clean

RUN rm -rf $CATALINA_HOME/webapps/*

COPY . $CATALINA_HOME/webapps/ROOT/

EXPOSE 8080

CMD ["catalina.sh", "run"]
