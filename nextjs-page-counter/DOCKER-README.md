How to build this example as a container and deploy to CF:

Build image:
```
docker build -t <repo>/mynextjs:latest .
```

Login to your repo and push the image:
```
docker login <repo>  # For dockerhub use: docker login registry-1.docker.io
                     # Note: DockerHub creates repos public by default, and limits free accounts to 1 private repo.
docker push <repo>/mynextjs:latest
```

Deploy to CF:
```
CF_DOCKER_PASSWORD=PASSWORD cf push -f manifest-docker.yml --docker-image <repo>/mynextjs:latest --docker-username USERNAME
```

See also:
- https://docs.cloudfoundry.org/devguide/deploy-apps/push-docker.html#registry
- https://docs.cloudfoundry.org/adminguide/docker.html
