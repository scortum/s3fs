FROM ubuntu
MAINTAINER scortum

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update && apt-get -y upgrade \
    apt-get -y install bash && \
    apt-get -y install build-essential libcurl4-openssl-dev libxml2-dev mime-support && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ... http://tecadmin.net/mount-s3-bucket-centosrhel-ubuntu-using-s3fs/#
# ... https://registry.hub.docker.com/u/ihealthtechnologies/s3-mount/

CMD ["/bin/bash"]

