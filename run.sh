source .env
export MSYS_NO_PATHCONV=1
docker run --rm --env-file ./.env -v $(pwd)/$KEY_FILE_FOLDER:$PROJECT_ROOT/$KEY_FILE_FOLDER $MELTANO_IMAGE run tap-ga4_one target-bq_one dbt-bigquery:build