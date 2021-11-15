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

#### Erlang
X is the version of erlang.

1.  Build the image from the Dockerfile
```
docker build -t erlangbytes/erlangX-diss-service -f ./dockerfiles/erlangX_dockerfile .
```

2.  Run docker
```
docker run -p 3000:3000 erlangbytes/erlang19-diss-service
```

3.  Ensure its running
```
curl -i localhost:3000
```
