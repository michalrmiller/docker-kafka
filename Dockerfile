FROM java:8

ENV MIRROR="https://dist.apache.org/repos/dist/release"
ENV VERSION="0.8.2.0"
ENV SCALA_VERSION="2.10"
ENV SHA1="0b1504661f369877af43458fd06299c1356a453f"

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