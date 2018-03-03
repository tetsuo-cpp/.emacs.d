#!/bin/sh

# Build container if it doesn't exist already.
docker build -t global_env .

# Symlink docker host to synchronize path with container.
# Nasty hack... is there a better way to do this?
sudo ln -fs ${PWD} /global_mount

# Keep container running in the background.
# We can now redirect global/gtags calls to this running container with 'docker exec'.
docker run -d --rm \
       -v ${PWD}:/global_mount:z \
       --name global_env \
       -t global_env \
       bash
