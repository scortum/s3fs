#!/bin/bash -e


error() {
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    echo "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    echo "Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi
  exit "${code}"
}
trap 'error ${LINENO}' ERR


build() {
  docker build -t s3fs .
}

rebuild() {
  docker build --no-cache -t s3fs . 
}

run() {
  docker stop s3fs || true
  docker rm s3fs || true
  docker run -d --name s3fs \
             -v /etc/localtime:/etc/localtime:ro \
             -v ~/s3fs/src/tmp:/tmp \
             -v ~/data-s3fs.scortum.com:/data \
             -p 6999:6999  \
             -p 2222:22  \
             s3fs
}

enter() {
  docker exec -it s3fs bash
}

bash() {
  docker run -it --rm \
             -v /etc/localtime:/etc/localtime:ro \
             -v ~/s3fs/src/tmp:/tmp \
             -v ~/data-s3fs.scortum.com:/data \
             -p 6999:6999  \
             s3fs bash
}



# Does a cleanup:
# http://www.projectatomic.io/blog/2015/07/what-are-docker-none-none-images/
#

clean() {
  local STOPPED_CONTAINERS=$(docker ps -a -q)
  [[ ${STOPPED_CONTAINERS} ]] && docker rm ${STOPPED_CONTAINERS}
  
  local DANGLING_IMAGES=$(docker images -f "dangling=true" -q)
  [[ ${DANGLING_IMAGES} ]] && docker rmi ${DANGLING_IMAGES}
}

help() {
  declare -F
}

if [[ $@ ]]; then
 "$@"
else
  build
fi

