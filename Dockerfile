FROM java:8

ENV MIRROR="https://dist.apache.org/repos/dist/release"
ENV VERSION="0.10.0.1"
ENV SCALA_VERSION="2.11"
ENV SHA1="47F077450DAC989313B807017A8DBD5CB447B1AD"

ENV FILE="kafka_${SCALA_VERSION}-${VERSION}.tgz"

LABEL kafka_version="${VERSION}"
LABEL scala_version="${SCALA_VERSION}"
LABEL kafka_sha1="${SHA1}"

# Download and sha1sum validate
WORKDIR /tmp
RUN echo "${SHA1}\t${FILE}" > checksum
RUN wget ${MIRROR}/kafka/${VERSION}/${FILE}
RUN sha1sum --check checksum

# Extract
RUN mkdir -p /opt/kafka
RUN tar --strip-components=1 -zxf ${FILE} -C /opt/kafka

# Clean up
RUN rm -rf /tmp/*

WORKDIR /opt/kafka

VOLUME ["/tmp/kafka-logs","/opt/kafka/logs","/opt/kafka/conf"]

ENTRYPOINT ["bin/kafka-server-start.sh"]
CMD ["conf/server.properties"]
