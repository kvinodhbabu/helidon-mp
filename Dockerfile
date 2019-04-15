FROM frolvlad/alpine-glibc:alpine-3.9

# update base image and download required glibc libraries
RUN apk update && apk add libaio && apk add libnsl 

RUN apk add --no-cache nss

#install node, git, python and cleanup cache
RUN apk add --update \
   nodejs \
   nodejs-npm \
   git \
   python \
  && rm -rf /var/cache/apk/*

RUN mkdir /app
#COPY libs /app/libs
COPY helidon-mp-0.0.1-SNAPSHOT.jar /app/

# get node app from git repo
RUN apk update
RUN apk fetch openjdk8
RUN apk add openjdk8
RUN apk update
RUN apk fetch curl
RUN apk add curl

EXPOSE 9081
CMD ["/bin/sh", "-c", "java -cp /app/helidon-mp-0.0.1-SNAPSHOT.jar com.helidon.codecard.mp.MyHelidonMain"]
