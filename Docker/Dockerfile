# Pull base image:
FROM ubuntu:18.04 as installer
MAINTAINER aplteam kai@aplteam.com

ARG DYALOG_RELEASE=18.2
ARG DYALOG_VERSION=${DYALOG_RELEASE}.45645
ARG DYALOG_DEBFILE=linux_64_${DYALOG_VERSION}_unicode.x86_64.deb
#ARG DOTNET_SDK=dotnet-sdk-2.2
#ARG DOTNET_RUNTIME=dotnet-runtime-3.1
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

######################### Install Dyalog APL
# Fetch Dyalog APL from the current directory
ADD ${DYALOG_DEBFILE} /tmp/DYALOG.deb

# Install and remove package
RUN dpkg -i /tmp/DYALOG.deb
RUN rm /tmp/DYALOG.deb
#############################################

RUN apt-get install -y zip
RUN apt-get install -y unzip

########################## Install .NET
# Fetch and install .NET
#WORKDIR tmp
#RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
#RUN dpkg -i ./packages-microsoft-prod.deb
#RUN rm ./packages-microsoft-prod.deb

# Installing at this point is likely to fail with "Unable to locate package dotnet-sdk-2.2"
# Apparently no file prod.list is created, so we do it ourself:
#RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/prod.list
#RUN mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
#RUN apt update

# Handle .NETCORE dependencies
#RUN apt install apt-transport-https

# Install .NET (CORE?!)
# RUN apt install ${DOTNET_SDK}
#RUN apt install -y ${DOTNET_RUNTIME}
##############################################

ADD entrypoint /
RUN sed -i "s/{{DYALOG_RELEASE}}/${DYALOG_RELEASE}/" /entrypoint
ENTRYPOINT ["/entrypoint"]

RUN mkdir -p /app 
RUN chmod 777 /app

# Don't do this too early, otherwise you might lack required permissions:
USER $USER_ID          

WORKDIR /home/tatin

# For investigating the image from the "inside" (disable ENTRYPOINT then):
#CMD /bin/sh 

