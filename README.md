# What is this about
Running Meltano as a container via Cloud Composer 2. Note that:
- It is only for EL, no T is performed here
- The architecture involves running Meltano container using the KubernetesPodOperator which runs the workload in Cloud Composer 2 GKE, which supports only `general-purpose` compute class which has no GPU

# Develop
**Performing configuration**
They are stored in a number of files
   - `meltano.yml`: Define the extract and load spec. <u>This is where most development happens</u>
   - `.env`: Project-level setting, used for everything
   - `set_secret.sh`: Set up secrets in Composer GKE as needed
   - `run_k8s.py`: Composer DAG. There's a section for mounting the secret in container, and contents are duplicated with .env however, can consider moving them to Cloud Composer environment variable

**Omitted items in code**
These items are declared in .gitignore, remember to account for them in the code:
   - `key-files/`: Folder for storing the key files e.g. SSH keys, service account keys, etc.
   - `.env`: Environment variables that are referred to in the `meltano.yml` file, please refer to `_non_meltano/.env_sample` for the variables we need to set for the project
   - `.meltano/`: Where the installed extractor/loader plugins and execution logs reside. Remember to install the plugins before your runs. If you encounter blank stderr, try re-install your plugins

# Local run
**Run without Docker**: 
- See if Meltano could run without containerization
```
source .env
meltano run tap-ga4 target-bigquery / meltano run tap-ga4_one target-bq_two
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
   - Create Cloud Composer resource with `_non_meltano/composer.tf`
   - Set Secret from key-files into Composer's GKE cluster with `_non_meltano/set_secrets.sh`
- After prerequisites are fulfilled, perform these regular development works:
   1. Push image to GCP Artifact Repository `_non_meltano/push.sh`
   2. Update the DAG file `_non_meltano/run_k8s.py`