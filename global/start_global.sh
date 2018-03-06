#!/bin/sh

# Keep container running in the background.
# We can now redirect global/gtags calls to this running container with 'docker exec'.
docker run -d --rm \
       -v ${PWD}:${PWD}:z \
       --name global_env \
       -t global_env \
       sh
