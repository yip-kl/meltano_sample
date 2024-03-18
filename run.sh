source .env
export MSYS_NO_PATHCONV=1
docker run --rm --env-file ./.env -v $(pwd)/key-files:/project/key-files meltano_bbm run tap-ga4 target-bigquery