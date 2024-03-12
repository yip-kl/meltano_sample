#!/bin/bash

# See if meltano could run without dockerization
# meltano run tap-ga4 target-bigquery

# Run meltano in container. If this is to be run on a CI/CD pipeline, the .env file should be passed as a secret
docker run --env-file ./.env meltano_bbm run tap-ga4 target-bigquery

