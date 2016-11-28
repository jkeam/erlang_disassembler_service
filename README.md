# Erlang Disassembler Service
[![Build Status](https://travis-ci.org/jkeam/erlang_disassembler_service.svg?branch=master)](https://travis-ci.org/jkeam/erlang_disassembler_service)

A micro-service that disassembles your Erlang code.

## Setup

### Prereq
1.  Docker

### Build Image
Some quick and useful docker commands:
  ```
  # connect to the running instance
  docker exec -it <container id> /bin/bash

  # see all containers
  docker ps -a

  # see all images
  docker images

  # delete container
  docker rm <container id>

  # delete image
  docker rmi <image id>
  ```

#### Erlang 19
1.  Build the image from the Dockerfile
  ```
  docker build -t erlangbytes/erlang19-diss-service -f ./dockerfiles/erlang19_dockerfile .
  ```

2.  Run docker
  ```
  docker run -p 8019:8019 -d -e ENV_PORT=8019 erlangbytes/erlang19-diss-service
  ```

3.  Ensure its running
  ```
  curl -i localhost:8019
  ```

#### Erlang 18
1.  Build the image from the Dockerfile
  ```
  docker build -t erlangbytes/erlang18-diss-service -f ./dockerfiles/erlang18_dockerfile .
  ```

2.  Run docker
  ```
  docker run -p 8018:8018 -d -e ENV_PORT=8018 erlangbytes/erlang18-diss-service
  ```

3.  Ensure its running
  ```
  curl -i localhost:8018
  ```

#### Erlang 17
1.  Build the image from the Dockerfile
  ```
  docker build -t erlangbytes/erlang17-diss-service -f ./dockerfiles/erlang17_dockerfile .
  ```

2.  Run docker
  ```
  docker run -p 8017:8017 -d -e ENV_PORT=8017 erlangbytes/erlang17-diss-service
  ```

3.  Ensure its running
  ```
  curl -i localhost:8017
  ```

