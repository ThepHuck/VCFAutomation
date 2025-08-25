# Storing any custom Dockerfiles here
docker-helm - this folder is specific to Intel's XEON AMX accelerator for [OPEA GenAI](https://github.com/opea-project) and [Enterprise-Inference](https://github.com/opea-project/Enterprise-Inference)
- custom ubuntu 22.04 image with openssh, curl, kubectl, & helm installed.
- v0.5.1 requires run.sh
- [docker hub](https://hub.docker.com/repository/docker/thephuck/docker-helm/general)

docker-helm-gaudi
- Dockerfile based on OPEA Dockerfile and separate run-gaudi.sh file
