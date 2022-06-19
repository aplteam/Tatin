# Pull base image:
FROM ubuntu:22.04 as installer
MAINTAINER aplteam kai@aplteam.com

ARG DYALOG_RELEASE=18.2
ARG DYALOG_VERSION=${DYALOG_RELEASE}.45645
ARG DYALOG_DEBFILE=linux_64_${DYALOG_VERSION}_unicode.x86_64.deb
ARG UID=1001
ARG GID=1001
ARG USER_ID=tatin

#ENV LANG en_GB.UTF-8
#ENV LANGUAGE en_GB:UTF-8
#ENV LC_ALL en_GB.UTF-8
ENV DYALOG_SERIAL 201837

RUN useradd --create-home --uid $UID $USER_ID

######################### Install latest patches
RUN apt update \
    && apt install -y \
    && apt install -y wget
################################################    

############################# Install Dyalog APL
# Fetch Dyalog APL from the current directory
ADD ${DYALOG_DEBFILE} /tmp/DYALOG.deb
################################################

##################### Install and remove package
RUN dpkg -i /tmp/DYALOG.deb
RUN rm /tmp/DYALOG.deb
################################################

RUN apt-get install -y zip
RUN apt-get install -y unzip
RUN apt-get install -y libtinfo5

ADD entrypoint /
RUN sed -i "s/{{DYALOG_RELEASE}}/${DYALOG_RELEASE}/" /entrypoint
ENTRYPOINT ["/entrypoint"]

RUN mkdir -p /app 
RUN chmod 777 /app

# We do this as late as possible to prevent lacking required permissions:
USER $USER_ID          

WORKDIR /home/tatin

# For investigating the image from the "inside" (disable ENTRYPOINT then):
#CMD /bin/sh 

