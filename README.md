# Local run
Note: These items are declared in .gitignore, remember to account for them in the code:
   - `key-files/`: Folder for storing the key files e.g. SSH keys, service account keys, etc.
   - `.env`: Environment variables that are referred to in the `meltano.yml` file

**Run without Docker**: See if Meltano could run without containerization
```
source .env
meltano run tap-ga4 target-bigquery
```
**Container run**: 
- **Build**: `docker compose build`
- **Run** `./run.sh`
   - `--rm`: Container should automatically be removed after we close docker. Otherwise we will end up with a lot of terminated containers
   - `--env-file` Run the container using the LOCAL env-file (i.e. no need to put the env-file into the container). Note:
    - It is already ignored in `.dockerignore`, so that .env file will not be exposed
   - `-v`: Mount the key files rather than copy them into the container, as security best practice. Note: These alternatives won't work:
      - `-v key-files:/project/key-files`: The source `key-files` will be considered as name of the volume, rather than as a source path for the mount
      - `-v ./key-files:/project/key-files`: Absolute path must be used
   - `export MSYS_NO_PATHCONV=1`: Necessary for Docker for Windows, else the mount would not work correctly, see [here](https://stackoverflow.com/questions/48427366/docker-build-command-add-c-program-files-git-to-the-path-passed-as-build-argu).
    - Also tried adding / prefix to destination instead of defining the environment variable e.g. `docker run --rm --env-file ./.env -v $(pwd)/key-files://project/key-files` but it does not work

 - **Debug**: Inspect container filesystem with `docker run --rm --env-file ./.env --entrypoint=bash -it meltano_bbm`
   - `-it` flag means an interactive container will launch instead of the shell just being started and immediately exiting


# Cloud Composer deployment
- Prerequisites:
   - Create Cloud Composer resource with `.non_meltano/composer.tf`
   - Set Secret from key-files into Composer's GKE cluster with `.non_meltano/set_secrets.sh`
- After prerequisites are fulfilled, perform these regular development works:
   1. Push image to GCP Artifact Repository `.non_meltano/push.sh`
   2. Update the DAG file `.non_meltano/run_k8s.py`

To try:
 - Define project/ root and .env file for Dockerfile and airflow, otherwise variables like /project and key file names are separately declared
 - Improve the DAG file with affinity
- Multiple extractor / target
- Check why the local run no longer work