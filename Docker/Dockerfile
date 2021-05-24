FROM debian:buster-slim as installer

ARG DYALOG_RELEASE=18.0
ARG DYALOG_VERSION=${DYALOG_RELEASE}.39712
ARG BUILDTYPE=minimal
ARG DEBFILE=https://www.dyalog.com/uploads/php/download.dyalog.com/download.php?file=${DYALOG_RELEASE}/linux_64_${DYALOG_VERSION}_unicode.x86_64.deb

ADD ${DEBFILE} /tmp/dyalog.deb
ADD rmfiles.sh /

RUN dpkg -i --ignore-depends=libtinfo5 /tmp/dyalog.deb && /rmfiles.sh

FROM debian:buster-slim

ARG DYALOG_RELEASE=18.0

RUN apt-get update && apt-get install -y --no-install-recommends locales && \
    apt-get clean && rm -Rf /var/lib/apt/lists/*             && \
    sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen    && \
    locale-gen

ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:UTF-8
ENV LC_ALL en_GB.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends libncurses5 && \
    apt-get clean && rm -Rf /var/lib/apt/lists/*

COPY --from=0 /opt /opt

ADD entrypoint /
RUN sed -i "s/{{DYALOG_RELEASE}}/${DYALOG_RELEASE}/" /entrypoint

RUN ln -s /run /usr/bin/dyalog
RUN useradd -s /bin/bash -d /home/dyalog -m dyalog
RUN mkdir /app /storage && \
    chmod 777 /app /storage

LABEL org.label-schema.licence="proprietary / non-commercial"   \   
      org.label-schema.licenceURL="https://www.dyalog.com/uploads/documents/Private_Personal_Educational_Licence.pdf"

EXPOSE 4502

USER dyalog
WORKDIR /home/dyalog
ENTRYPOINT ["/entrypoint"]


