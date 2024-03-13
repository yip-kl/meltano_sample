Build using `docker compose build`

Run
export MSYS_NO_PATHCONV=1
docker run --rm --env-file ./.env -v $(pwd)/key-files:/project/key-files meltano_bbm run tap-ga4 target-bigquery -> OK!!

https://stackoverflow.com/questions/65267274/why-doesnt-docker-compose-mount-my-volume

Run
- **Local run**: See if meltano could run without dockerization `meltano run tap-ga4 target-bigquery`
- **Container run**: Run meltano in container with `docker run --rm --env-file ./.env meltano_bbm run tap-ga4 target-bigquery`
 - `--env-file` Run the container using the LOCAL env-file (i.e. no need to put the env-file into the container). If this is to be run on a CI/CD pipeline, the `.env-file` should be passed as a secret. It is ignored in `.dockerignore`, so that .env file will not be exposed
 - `--rm`: Container should automatically be removed after we close docker
- **Debug filesystem**: `docker run --env-file ./.env --entrypoint=bash -it meltano_bbm`
 - `-it` flag means an interactive container will launch instead of the shell just being started and immediately exiting

To try:
 - Move the docker run long command line into docker compose
 - Terraform template
 - Multiple extractor / target
 - Consolidate the variables under .env rather than scattered also in meltano.yml


trying to inspect docker filesystem