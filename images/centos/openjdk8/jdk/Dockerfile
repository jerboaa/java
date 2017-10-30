FROM centos:7

USER root

RUN mkdir -p /deployments

# JAVA_APP_DIR is used by run-java.sh for finding the binaries
ENV JAVA_APP_DIR=/deployments

# /dev/urandom is used as random source, which is prefectly safe
# according to http://www.2uo.de/myths-about-urandom/
RUN yum install -y \
       java-1.8.0-openjdk  \
       java-1.8.0-openjdk.i686  \
       java-1.8.0-openjdk-devel \
       java-1.8.0-openjdk-devel.i686 \
    && echo "securerandom.source=file:/dev/urandom" >> /usr/lib/jvm/java/jre/lib/security/java.security
COPY set_java.sh /
RUN /set_java.sh && rm /set_java.sh
RUN java -version

# Agent bond including Jolokia and jmx_exporter
ADD agent-bond-opts /opt/run-java-options
RUN mkdir -p /opt/agent-bond \
 && curl http://central.maven.org/maven2/io/fabric8/agent-bond-agent/1.0.2/agent-bond-agent-1.0.2.jar \
          -o /opt/agent-bond/agent-bond.jar \
 && chmod 444 /opt/agent-bond/agent-bond.jar \
 && chmod 755 /opt/run-java-options
ADD jmx_exporter_config.yml /opt/agent-bond/
EXPOSE 8778 9779 8080

LABEL io.openshift.s2i.scripts-url=image:///usr/libexec/s2i
COPY ./s2i /usr/libexec/s2i
RUN chmod -R 755 /usr/libexec/s2i

# Add run script as /deployments/run-java.sh and make it executable
COPY run-java.sh debug-options container-limits java-default-options /deployments/
RUN chmod 755 /deployments/run-java.sh /deployments/java-default-options /deployments/container-limits /deployments/debug-options

RUN useradd -u 1001 -r -g 0 -d /deployments -s /sbin/nologin \
    -c "Default Application User" default && \
    chown -R 1001:0 /deployments && \
    chmod g+w /deployments

USER 1001

CMD [ "/usr/libexec/s2i/usage" ]
