Build using `docker compose build`
Run using `./exec.sh`

Notes:
 - `/.env` is ignored in `.dockerignore`, so that .env file will not be exposed
 - Try: Avoid putting the key file into the container, should control as environment variables
 - Try: Consolidate the variables under .env rather than scattered also in meltano.yml

 # [NOT PREFERRED] Copy keys into the container, in case those keys cannot be stored as environment variables
# COPY ./service-accounts ./service-accounts