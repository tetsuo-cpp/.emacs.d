#!/bin/sh

# Build container if it doesn't exist already.
docker build -t global_env .

# Keep container running in the background.
# We can now redirect global/gtags calls to this running container with 'docker exec'.
docker run -d --rm \
       -v ${PWD}:/${PWD}:z \
       --name global_env \
       -t global_env \
       bash
