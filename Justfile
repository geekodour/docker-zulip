docker_builder := "bob"
docker_tag := "geekodour/zulip:8.3.1"
docker_platforms := "linux/arm64,linux/amd64"
docker_build_cache := ".cache/docker_build_cache"

# Build and push multi-arch image
docker-build-push-multi-arch: docker-multi-arch-builder
    #!/usr/bin/env bash
    docker buildx build \
    --builder={{docker_builder}} \
    --tag {{docker_tag}} \
    -o type=image,push=true \
    --cache-from=type=local,src={{docker_build_cache}} \
    --cache-to=type=local,mode=max,dest={{docker_build_cache}} \
    --platform={{docker_platforms}} .

# Build docker image for local use
docker-build-local:
    docker buildx build --tag {{docker_tag}} .

# docker multiarch builds need custom builder
[private]
docker-multi-arch-builder:
    docker buildx rm -f {{docker_builder}}
    docker buildx create --name={{docker_builder}} --driver=docker-container
